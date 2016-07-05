#!/bin/bash
root=$PWD

do_build ()
{
	set -e
	version=$1
	export PATH=$HOME/$version/bin:$PATH
	conda install conda-build anaconda-client anaconda-build
	python --version
	bdir=~/$version/conda-bld
	rm -rf $bdir
	rm -rf dist
	conda config --set anaconda_upload no
	conda build .
	conda convert --platform all $bdir/linux-64/px4tools*.tar.bz2 -o ~/$version/conda-bld

	anaconda upload -u dronecrew $bdir/linux-64/px4tools*.tar.bz2 || true
	anaconda upload -u dronecrew $bdir/linux-32/px4tools*.tar.bz2 || true
	anaconda upload -u dronecrew $bdir/win-32/px4tools*.tar.bz2 || true
	anaconda upload -u dronecrew $bdir/win-64/px4tools*.tar.bz2 || true
	anaconda upload -u dronecrew $bdir/osx-64/px4tools*.tar.bz2 || true
	# anaconda build submit --tail .
}

do_build anaconda2
do_build anaconda3

#cd $root
#python setup.py sdist upload
