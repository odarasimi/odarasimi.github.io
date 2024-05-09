#!/bin/sh
# "#################################################"
# "This file is modified from a Gist, located here:"
#    "https://gist.github.com/BillRaymond/db761d6b53dc4a237b095819d33c7332#file-post-run-txt"
# "Steps to finalize a Docker image to use GitHub Pages and Jekyll"
# "Instructions:"
# " 1. Open a terminal window and cd into your repo"
# " 3. Run the script, like this:
# "      sh script-name.sh"
# "#################################################"

# Display current Ruby version
echo "Ruby version"
ruby -v

# Display current Jekyll version
echo "Jekyll version"
jekyll -v

# Add a blank Jekyll site
# echo "Create a new Jekyll site"
# NOTE: Want a blank site? Uncomment the following line
#       and also comment out the next "Add Jekyll site" lines
# echo "Create a new Jekyll blank site"
# jekyll new . --skip-bundle --force --blank

# Add Jekyll site
echo "Create a new Jekyll site with the default theme"
jekyll new . --skip-bundle --force

# Jekyll creates a .gitignore file, but it can be improved, so delete it
# NOTE: Comment out the following lines if you want to keep the original .gitignore file 
echo "Deleting default .gitignore file Jekyll generated"
GITIGNORE=.gitignore
if test -f "$GITIGNORE"; then
    rm $GITIGNORE
fi

# Create a new .gitignore file and populate it
# NOTE: Comment out the following lines if you want to keep the original .gitignore file
echo "Create a new .gitignore file"
touch $GITIGNORE

# Populate the new .gitignore file
# NOTE: Comment out the following lines if you want to keep the original .gitignore file
echo "Populating the .gitignore file"
echo "_site/" >> $GITIGNORE
echo ".sass-cache/" >> $GITIGNORE
echo ".jekyll-cache/" >> $GITIGNORE
echo ".jekyll-metadata" >> $GITIGNORE
echo ".bundle/" >> $GITIGNORE
echo "vendor/" >> $GITIGNORE
echo "**/.DS_Store" >> $GITIGNORE

# Configure Jekyll for GitHub Pages
echo "Add GitHub Pages to the bundle"
bundle add "github-pages" --group "jekyll_plugins" --version 231

# webrick is a technology that has been removed by Ruby, but needed for Jekyll
echo "Add required webrick dependency to the bundle"
bundle add webrick

# Install and update the bundle
echo "bundle install"
bundle install
echo "bundle update"
bundle update

# Get the presumed value for the baseurl (this folder name)
var=$(pwd)
BASEURL="$(basename $PWD)"