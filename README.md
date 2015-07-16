# elm-scroll-table 

[demo](http://justinwoo.github.io/elm-scroll-table)

a scroll table done in elm using the standard architecture

painfully made in the course of something like 10 hours.

## my reactions:

the good:

1. most compilation errors are very straightforward and helpful
2. types & signatures are pretty useful
3. easy to get started
4. `import PACKAGE exposing (CONTENTS)` is a billion times easier to read imo than `import {CONTENTS} from PACKAGE`
5. vdom trees aren't too painful to create
6. even naively letting a billion events fire off isn't slow

the bad:

1. some compilation errors are super confusing and the messages shown don't show correctly where the errors came from (e.g. `floor (bindingForInt / 23)` vs `bindingForInt / 232` will throw way different errors)
2. deciphering types takes quite a while sometimes
3. not enough docs, have to read source code a lot more than with other things
4. this version does less than my cljs/JS versions with more code
5. destructured bindings have some kind of messed up type behavior that can make them quite annoying to work with (e.g. number -> Int resolution)
6. querying the DOM for things can get quite awkward when you cant just go `e.property.whatever`

not their fault:

1. positioning of elements in a scrolling pane can get totally FUBAR'd thanks to chrome
2. not enough community to have a lot of basic/simple quesitons answered.
3. i used a shit ton of parens because i dont know how you're supposed to make sure certain operations go through first (shit ain't no PEMDAS)
4. i don't know how to throttle events with this.
5. related to 3 -- can't just google everything.

## conclusion:

would write again, since the compiler throws useful errors most of the time and type signatures help me catch mistakes more easily.

if there's anything that's wrong or stupid, let me know via tweetstorm [@jusrin00](https://twitter.com/jusrin00) or the issues.

if you actually read this README, thanks for reading!
