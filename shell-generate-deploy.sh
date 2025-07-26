#!/bin/bash

echo "🚀 Generating Swagger UI deployment files..."

# Step 1: Clean and build the project
echo "📦 Building Swagger UI..."
npm run build

# Step 2: Remove existing deployment folder and recreate
echo "🗂️  Creating deployment folder..."
rm -rf swagger-ui-deploy
mkdir swagger-ui-deploy

# Step 3: Copy only the necessary dist files (exclude package.json)
echo "📋 Copying distribution files..."
cp dist/*.html swagger-ui-deploy/ 2>/dev/null || true
cp dist/*.css swagger-ui-deploy/ 2>/dev/null || true
cp dist/*.js swagger-ui-deploy/ 2>/dev/null || true

# Step 4: Copy OpenAPI spec
echo "📄 Copying OpenAPI specification..."
cp dev-helpers/example/bid2bill-openapi-spec.json swagger-ui-deploy/

# Step 5: Update swagger-initializer.js to use local spec
echo "⚙️  Configuring Swagger initializer..."
cat > swagger-ui-deploy/swagger-initializer.js << 'EOF'
window.onload = function() {
  //<editor-fold desc="Changeable Configuration Block">

  window.ui = SwaggerUIBundle({
    url: './bid2bill-openapi-spec.json',
    dom_id: '#swagger-ui',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [
      SwaggerUIBundle.plugins.DownloadUrl
    ],
    layout: "StandaloneLayout"
  });

  //</editor-fold>
};
EOF

echo "✅ Deployment files generated successfully!"
echo ""
echo "🧪 To test locally, run:"
echo "   cd swagger-ui-deploy && npx serve . -l 3002"
