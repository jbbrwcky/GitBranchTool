# GitBranchTool

Useful bash scripted function to use when you have a lot of git branches
or branches that have long names. An example of a 'git branch' command
output:

UserOne/Project1-100-Some-Html-Code
UserOne/Project1-149-Some-CSS-Code
UserOne/Project1-150-Some-SCSS-Code
UserOne/Project1-223-Some-Angular-Controller
UserOne/Project1-244-Some-Angular-Directive
UserOne/Project1-301-Some-Angular-Service

As you might see, switching to each one manually via 'git checkout' is
going to be a bit laborious even with tab completion.

So this tool makes that quicker and much easier to deal with. Now all you
have to do is type the command and an identifying (unique) branch name
so for example:

ggo 149

This will search the git branch and automatically switch to the branch
that has the 149 in it (UserOne/Project1-149-Some-CSS-Code). More than
that this will, if you give it something that isn't unqiue, give you a
list of possible branches to switch to. It will expect an input in the
form of an index (which it provides for you) so all you have to do is
input the index and it switches.
