#!/bin/bash

function new_file {
  local filepath="$1"
  local name="$2"
  local classtype="$3"
  local section="$4"
  touch "$filepath"
  if [ "$classtype" == "element" ]; then
    echo $'\n'"local ${name} = require '${classtype}' :new {"$'\n'"  __type = '${name}'"$'\n'"}"$'\n'$'\n'"return ${name}"$'\n' \
    | cat > "$filepath"
  elif [ "$classtype" == "controller" ]; then
    echo $'\n'"local ${name} = require '${classtype}' :new { '${section}' }"$'\n'$'\n'"return ${name}:new {}"$'\n' \
    | cat > "$filepath"
  elif [ "$classtype" == "model" ]; then
    echo $'\n'"local ${name} = require '${classtype}' :new {}"$'\n'$'\n'"return ${name}:new {}"$'\n' \
    | cat > "$filepath"
  fi
}

echo "Type the name of the element"
read element

echo "Type the name of its model"
read model

echo "Type the name of the model section"
read model_section

echo "Type the name of its main controller (or type 'no' for no main controller)"
read controller

if [ "$model_section" ]; then
  mkdir -p "src/models/${model_section}"
  mkdir -p "src/controllers/${model_section}"
fi

if [ "$element" ]; then
  new_file "src/elements/${element}.lua" "${element}" "element"
fi

if [ "$model" ]; then
  new_file "src/models/${model_section}/${model}.lua" "${model}" "model" "$model_section"
fi

if [ "$controller" ] && [ "$controller" != "no" ]; then
  new_file "src/controllers/${model_section}/${controller}.lua" "${controller}" "controller" "$model_section"
fi
