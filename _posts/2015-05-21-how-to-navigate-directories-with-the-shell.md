---
layout: default
title: How to navigate directories faster with bash
---

# How to navigate directories faster with bash



During my everyday work as a knowledge worker running calculations, analyzing data, and developing code from the command-line *changing directories* is an extremely frequent activity.  In fact changing directories is the basic mode of operation to walk between different tasks, context, or work spaces. When first started  using the shell the only command I knew was `cd` but throughout the years I noticed that there is a lot more under the hood of bash that significantly reduces the time needed to change directories. Below I share the 4 tricks I use frequently to jump to directories which not only helps me to work faster but also helps me to concentrate more on the content of work and less on the cognitive load of remembering long subdirectories. Furthermore I use all tricks together for maximum efficiency and I hope they make you more productive, too.


## Max Out cd


This first tip focuses solely on using all capabilities of the `cd` command.  The most common form of using `cd` is

    cd directory

where `directory` can be either a `./relative` or an `/absolute` path. Also quite well-known is that `..` is an alias for the directory above the current directory, `../..` the one above that and so on. Maybe less well-known is that `~` is an alias for one's home directory. However an even faster way to go there directly is to skip the `directory` argument and just use

    cd

Furthermore `-` is an alias for the previous directory. So `cd -` is like a back-button for `cd` that works for exactly one step in the history. Using `cd -` repeatedly results in jumping back and forth between two directories.

I also find it useful to alias `cd ..` like

    alias ..="cd .."

and there is no reason to stop there, so adding

    alias ...="cd ../.."
    alias ....="cd ../../../"
    alias .....="cd ../../../.."
    ....

can bring you up many more directories by just adding dots (...) :-).


Another neat short hand is `!$` which is an alias for the last argument of the previous command. This can be handy if one creates a new directory and wants to change into it without typing the the directory again. So commands would be

    mkdir -p make/new/directory
    cd !$

and you are there.

[up](#top)

## Configure $CDPATH to your workflow

The next tip is efficient use of the `CDPATH` variable. Almost everyone using a shell is familiar with the importance of the `PATH` variable. The `PATH` variable means that whenever one enters a `command` the shell will look up the directories listed in the `PATH`, search for executable files and then executes the first executable it finds named `command` in the order listed in `PATH`.

So there is a closely related variable named CDPATH which is the analog for `cd`. When you enter

    cd directory

`cd` will search all directories listed in `CDPATH` and jump to the first directory it finds in the order listed in `CDPATH`. The default setting is `CDPATH=.`, which means `cd` only searches the current working directory.  But there is no reason to stop where. My `~/.bashrc` contains export CDPATH=.:~:~/src:~/calculations:~/ssh_mounts

With this line I can always directly jump directly to any directory below the current directory, the home directory, a directory named `src` for software projects, a directory for `calculations`, and a directory named `ssh_mounts` that may link to other servers linked via the [sshfs](http://de.wikipedia.org/wiki/SSHFS) program.

This helps to keep directories for different types of activities apart while also allowing for quick changes between them. It is more powerful if one has only one `~/.bashrc` for all user accounts and synchronizes it using e.g. [git](https://git-scm.com/), and bash completion

    if [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    elif [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
      . /opt/local/etc/profile.d/bash_completion.sh
    fi


Another neat bash option is

    shopt -s cdspell

which automatically corrects small typos in directory names and jumps to the best guess of existing directories.

[up](#top)

## Turbo-charge cd with push/popd

Another command less well known than `cd` is `pushd` and `popd`.  `pushd` stands for *push directory* and it changes the current working directory but also *pushes* the directory that one left onto a history stack.  `popd` on the other hand stands for *pop directory* which *pops* the last visited directory from the history stack. The command `dirs` lists the directories currently stacked on the history. So for example

    pushd a
    pushd b
    pushd c
    popd

brings you to directory `b`.

`pushd` and `popd` are two really great commands and they are hugely useful in scripts to cleanly enter and exit directories in shell-scripts. The only question is why there are so many characters to type and why `cd` doesn't have that feature built in. To fix this put the following two functions into your `~/.bashrc` which overrides `cd`:

    function cd() {
      if [ "$#" = "0" ]
      then
      pushd ${HOME} > /dev/null
      elif [ -f "${1}" ]
      then
        ${EDITOR} ${1}
      else
      pushd "$1" > /dev/null
      fi
    }

    function bd(){
      if [ "$#" = "0" ]
      then
        popd > /dev/null
      else
        for i in $(seq ${1})
        do
          popd > /dev/null
        done
      fi
    }

Extra bells and whistles in those function are

- instead of `popd` you can also use `bd` like `back directory`
- `bd` also accepts a number `n` as an argument which let's you step back `n` directories at a time
- if the `cd` argument is a file instead of a directory it will assume that you want to edit it as a text file and open it in you favorite editor.

You can still use `dirs` to list the history and adjust the function above to your taste.

[up](#top)

## Jump more efficiently into the history


The last tip is a short but powerful one to faster reuse commands from the history. Basically the up-arrow jumps to the previous command in the history. However this quickly becomes very tedious if one jumps 5 or 10 or more commands back in history. Instead if
you put

    bind '"\e[A":history-search-backward'
    bind '"\e[A":history-search-backward'

into your `/.bashrc` and had started typing part of a command it will only jump to those commands in the history that also start with the same fragment of a command. This is actually quite useful for any command line work and therefore the default setting in [IPython](http://ipython.org/) but also useful for `cd`. So

    cd <up-arrow><up-arrow> ...

let's you quickly navigate through previous `cd` commands.

[up](#top)
