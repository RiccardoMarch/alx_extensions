#!/bin/bash

token="ADD_YOUR_TOKEN_HERE"
user="ADD_YOUR_USERNAME_HERE"

function request_init() {
    read -p "Do you want to setup repository? (y/n) " yn
    
    var=${yn^h}

    case $var in
        y|yes)
            true
            return;;
        n|no)
            false
            return;;
    esac

    request_init
    return 
}

# This function handles all the cloning of a repo
function clone_repo() {
    url="https://$token@github.com/$user/$1.git"
    git clone $url

    echo "Url : $url"
    echo ""
    if request_init; then
        read -p "Please enter a readme description : " r_str
        read -p "Please enter a commit message : " c_str

        cd ./$1

        echo "$r_str" > README.md

        git add README.md
        git commit -m "$c_str"
        echo ""
        git branch -M main
        git push -u origin main
        echo ""
    fi

    echo "Cloning done..."
}

# This function just pushes updates to a branch
function push_repo() {
    git add .
    git commit -m "$1"
    git push

    echo ""
}


if [ $# == 0 ]; then
    echo "Please enter a valid argument"
    exit 1

else
    case "$1" in
        -c)
            clone_repo $2;;
        -p)
            push_repo $2;;
    esac
fi
