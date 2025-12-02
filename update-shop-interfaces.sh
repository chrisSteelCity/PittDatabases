#!/bin/bash

# Update web-portal shop.ts
sed -i 's/stock: number;$/stock: number;\n  isActive: boolean;/' "web-portal/src/app/services/shop.ts"

# Update userPortal shop.service.ts
sed -i 's/stock: number;$/stock: number;\n  isActive: boolean;/' "userPortal/src/app/services/shop.service.ts"

echo "Updated isActive field in both shop service files"
