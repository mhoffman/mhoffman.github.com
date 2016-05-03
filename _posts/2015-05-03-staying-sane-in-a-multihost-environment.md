---
layout: default
title: How to Stay Sane in A Multihost Environment
---


# How to Stay Sane in A Multihost Environment

Consider the following scenario: you are routinely logging in and out of several different clusters or hosts. On some machines you need some special settings, environment variables, shortcuts. Then there are nifty terminal shortcuts which you acquired over time and you put them into your `.bashrc` in machine A and you would like to have them on machine B. But first that means that you need to log into machine copy that code and put it into the `.bashrc` on machine B, `source ~/.bashrc`. While you do that you notice that some nifty hack/alias/function on machine B might also be useful on machine B. But that nifty aliases come mixed in a code block of which some lines you already on machine A.  Now what do you do? You could give up leaving with all these fragmented work environments and never remember what command works where.  Or you could just copy the entire file on machine B over the one at machine A since everything is now already merged on B. Great!  But hey wasn't there this one line on machine A which sets this variables that took you 2.5 hours to figure out but it is crucial for submitting jobs in parallel or linking with the latest, greatest working version of MKL? Does it sound familiar?

Believe me, I have been in this situation many times and pulled a lot of hair. But don't despair there is hope and a solution and it involves only two simple steps that once you have done it, life will be much more colorful again and you will never want to go back :-). For sake of simplicity I will assume that you are working with bash, but similar approaches can be easily cooked up with any other terminals.


## Step 1: Have one bashrc and one bashrc only

The trick here is to make your `.bashrc` aware where and by which operating system it is executed. There is a set of commands that is installed on the majority of UNIX system that help you figure this out. Take this snippet for starters

```
# Determine platform first
export platform='unknown'
uname=$(uname)
if [[ "x${uname}" == "xDarwin" ]]; then
    export platform='mac'
elif [[ "x${uname}" == "xLinux" ]]; then
    export platform='linux'
fi

export dnsdomainname='unknown'
if which dnsdomainname >/dev/null; then
    export dnsdomainname=$(dnsdomainname)
else
    export dnsdomainname='unknown'
fi

export domainname='unknown'
if which domainname >/dev/null; then
    export domainname=$(domainname)
else
    export domainname='unknown'
fi

export hostname='unknown'
if which domainname >/dev/null; then
    export hostname=$(hostname)
else
    export hostname='unknown'
fi
```

This can be refined or made more widely compatible but it is a good starting point.


## Step 2: Keep your dotfiles in sync everywhere

This is where a bit of source control comes in. If you are already using version control on your projects (as you should) this will come naturally. If you don't just do it because it doesn't hurt and become more productive on various other software projects and others. If you are unsure where to start I recommend [Git](https://git-scm.com/) or [Mercurial](https://www.mercurial-scm.org/) since the are widely supported distributed version control systems.

To this end we create a directory where we keep all our dotfiles and only create links to the `~` home directory on every host we ever directly work on. I keep this directory at `~/src/dotfiles` but you should put it wherever you see fit in your directory structure. Inside the directory you put only one script that creates the necessary softlinks from `~` to this directory. This way we avoid to overwrite existing dotfiles on a new host by accident and future changes to dotfiles become immediately available (apart from a  `source ~/.bashrc` or something along those lines).

For the bare bones structure we create the following files and directories in `~/src/dotfiles`

```
mkdir -p ~/src/dotfiles
```

and populate it with a minimal content

```
mkdir -p ~/src/dotfiles/scripts
touch ~/src/dotfiles/bashrc
touch ~/src/dotfiles/vimrc
touch ~/src/dotfiles/gitconfig
touch ~/src/dotfiles/install_dotfiles
chmod 755 ~/src/dotfiles/install_dotfiles
```

You can checkout this [gist](https://gist.github.com/4a5f34aaca066bb8469be26f36c7edb3) to see what I put in those files.

To synchronize this dotfiles repository with your other hosts I we use github.com as a hosting platform. If you don't already
have an account create one and come back. This tutorial will wait ... great! We first create a local repository and add all files
to it

```
git init
git add -a
git commit -m"Initial commit."
```

Next we install githubs practical [hub tool](https://github.com/github/hub) and create a corresponding github repository by issuing

```
hub create
git push origin master
```


All we now have to do is to login into our other hosts and clone the repository with

```
git clone https://github.com/<your-github-user>/dotfiles.git
```

and run

```
cd dotfiles
./install_dotfiles
```

Voilà!
