#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p audios
if ! say -v '?' | grep -Fq 'Isabela (Enhanced)'; then
  echo 'Falta la voz Isabela (Enhanced). Instalála desde Ajustes del Sistema > Accesibilidad > Contenido hablado.'
  read -r -p 'Presioná Enter para salir...'; exit 1
fi
if ! say -v '?' | grep -Eq '^Daniel[[:space:]]+en_GB'; then
  echo 'Falta Daniel (en_GB). Verificá las voces con: say -v "?"'
  read -r -p 'Presioná Enter para salir...'; exit 1
fi
count=0
for file in textos/*.txt; do
  name="$(basename "$file" .txt)"
  if [[ "$name" == alicia_* || "$name" == ejemplo_* || "$name" == contraste_* || "$name" == formula_* ]]; then
    voice='Daniel'; rate=150
  elif [[ "$name" == mixto_* ]]; then
    if [[ "$name" == mixto_* ]]; then
      # La tabla generada a continuación define qué clips de las explicaciones son ingleses.
      if grep -Fxq "$name" audios_ingles.txt; then voice='Daniel'; rate=150
      else voice='Isabela (Enhanced)'; rate=145; fi
    fi
  else
    voice='Isabela (Enhanced)'; rate=145
  fi
  if [[ -s "audios/$name.m4a" ]]; then continue; fi
  echo "Generando $name ($voice) ..."
  say -v "$voice" -r "$rate" -f "$file" -o "audios/$name.aiff"
  afconvert -f m4af -d aac "audios/$name.aiff" "audios/$name.m4a"
  rm -f "audios/$name.aiff"
  count=$((count+1))
done
echo "LISTO: $count audios nuevos. Isabela en español y Daniel en inglés."
read -r -p 'Presioná Enter para cerrar...'
