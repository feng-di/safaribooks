#!/bin/bash

BASE_DIR=$(pwd)
BOOKS_DIR=/Books/*
BOOKS_CONVERTED_DIR=/Books_CLEAR

check_cmd() {
  if ! command -v $1 &> /dev/null
  then
      echo "Command $1 does not exist, install callibre to have it!"
      exit 1
  fi
}

main() {
  for dir in ${BASE_DIR}${BOOKS_DIR}
  do
    echo -e "\n---------------------------------> Convert book in folder : ${dir}\n"
    cd "${dir}"
    toConvert="true"

    for epub in ./*.epub
    do
      echo "debug - epub: ${epub}"
      if [[ ${epub} == *"_CLEAR.epub" ]]
      then
        toConvert="false"
      fi
    done

    for epub in ./*.epub
    do
      echo ${toConvert}
      if [ ${toConvert} == "true" ]
      then
        echo "--> Begin convert book : ${epub}"
        extension="${epub##*.}"
        filename=$(basename ${epub%.*})
        newFilename="${filename}_CLEAR.${extension}"

#        echo "debug - do process : -----${extension} # ${filename} # ${newFilename})"
        ebook-convert  ${epub} ${newFilename}
        echo -e "---> copy file to : ${BASE_DIR}${BOOKS_CONVERTED_DIR}${newFilename}\n"
        cp ${newFilename} ${BASE_DIR}${BOOKS_CONVERTED_DIR}/${newFilename}
      else
        echo "--> The directory is already converted !"
        break
      fi
    done
  done
}

check_cmd ebook-convert

echo "Begin convert books in folder ${BOOKS_DIR}, are you sure? [Y/n]"
select yn in "Yes" "No"
do
  case $yn in
      Yes ) main ; exit ;;
      No ) echo -e "Do nothing"; exit ;;
  esac
done
