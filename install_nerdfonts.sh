#!/bin/bash
# install_nerdfonts.sh

echo "Instalando Nerd Fonts optimizadas..."

# Crear directorio si no existe
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

# Descargar solo las necesarias (evitar todas las Nerd Fonts)
echo "Descargando Cascadia Code Nerd Font (recomendada)..."
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip
unzip -q CascadiaCode.zip -d CascadiaCode
rm CascadiaCode.zip *.md *.txt 2>/dev/null

# Limpiar archivos innecesarios (solo dejar Regular y Bold)
find CascadiaCode -type f ! -name "*Complete Windows Compatible*" ! -name "*Regular*" ! -name "*Bold*" -delete 2>/dev/null

# Configurar fuentes
fc-cache -fv

# Configurar terminal automáticamente
if [[ "$XDG_CURRENT_DESKTOP" =~ "XFCE" ]]; then
  # Para xfce4-terminal
  cat > ~/.config/xfce4/terminal/terminalrc << 'EOF'
[Configuration]
FontName=CaskaydiaCove Nerd Font Mono 10
EOF
  echo "Fuente configurada en xfce4-terminal"
fi

echo "✅ Fuentes instaladas. Reinicia tus terminales."
