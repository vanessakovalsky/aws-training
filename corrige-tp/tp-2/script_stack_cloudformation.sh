#!/bin/bash

usage="Usage: $(basename "$0") stack-name [aws-cli-opts]
where:
  stack-name   - the stack name
  aws-cli-opts - extra options passed directly to create-stack/update-stack
"

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "help" ] || [ "$1" == "usage" ] ; then
  echo "$usage"
  exit -1
fi

if [ -z "$1" ] || [ -z "$2" ] ; then
  echo "$usage"
  exit -1
fi

echo "Vérifie si la stack existe ..."

if ! aws cloudformation describe-stacks --stack-name $1 ; then

  echo -e "La stack n'existe pas, nous la créons ..."
  aws cloudformation create-stack \
    --stack-name $1 \
    ${@:2}

  echo "En attente de la création de la stack ..."
  aws cloudformation wait stack-create-complete \
    --stack-name $1 \

else

  echo "La stack existe, mise à jour ..."

  set +e
  update_output=$( aws cloudformation update-stack \
    --stack-name $1 \
    ${@:2}  2>&1)
  status=$?
  set -e

  echo "$update_output"

  if [ $status -ne 0 ] ; then

    # Don't fail for no-op update
    if [[ $update_output == *"ValidationError"* && $update_output == *"No updates"* ]] ; then
      echo "Fin de la création / mise à  jour. Aucune création / mise à jour possible"
      exit 0
    else
      exit $status
    fi

  fi

  echo "Attendre que la stack soit complète ..."
  aws cloudformation wait stack-update-complete \
    --stack-name $1 \

fi

echo "La création/ mise à jour a été effectuée correctement!"