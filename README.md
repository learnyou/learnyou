# learnyou

This will eventually be the source code for <http://learnyou.org>. At
the moment, it's just a web application you can run on localhost.

learnyou is written in the [Haskell programming language][2], with the
[Yesod web stack][3].

The code is licensed under the [GNU Affero General Public License][4].

## I don't know what any of that means. Educate me.

If you are an experienced coder, and want the tl;dr, see the
[Contributing][8] section.

If you aren't an experienced coder, that's fine. If you're looking to
contribute to any old open-source project, [LYSA][9] (the subject of the
website for which this is the source code) might be a better choice.
The required background knowledge to contribute to LYSA is fairly
minimal compared to this project.

Nonetheless, if you really want to contribute to this project:

1. You should read [bitemyapp's guide][7] to learning the Haskell
   programming language.
2. Read [the Yesod book][10] for learning Yesod.
3. Read [the Git book][11] for learning how to use git.
3. Read [the Contributing section of this document][8] for contributing
   to this project.

## Contributing

Contributions are welcome.

*   If you notice a bug, or have a question, you can

    +   [report it in the bug tracker][1],
    +   or email `peter@harpending.org`

*   If you want to make a change to the code, you are welcome to. To get
    your changes merged, you can

    +   use GitHub's pull-request system.
    +   open an issue/email me with a pull URL, and a small summary of
        the changes you made.

At the moment, to test the site, you have to download and compile it
yourself. To do that, you need

1. [git][5]
2. [stack][13]

To download, and install:

    git clone https://github.com/learnyou/learnyou.git
    cd learnyou
    stack setup
    stack build -j 5

To run:

    stack exec -- yesod devel

To view, open up `http://localhost:3000` in your web browser.

## Contact

* Email: `peter@harpending.org`
* IRC: `pharpend` on FreeNode and OFTC
* IRC channel for this project: [`#lysa` on FreeNode][12]

[1]: https://github.com/learnyou/learnyou/issues/new
[2]: https://www.haskell.org/
[3]: http://www.yesodweb.com/
[4]: https://www.gnu.org/licenses/agpl
[5]: https://git-scm.herokuapp.com/book/en/v2/Getting-Started-Installing-Git
[7]: https://github.com/bitemyapp/learnhaskell
[8]: #contributing
[9]: http://learnyou.org/lysa.html
[10]: http://www.yesodweb.com/book
[11]: https://git-scm.herokuapp.com/book/en/v2
[12]: https://webchat.freenode.net/?channels=%23lysa
[13]: https://github.com/commercialhaskell/stack/wiki/Downloads
