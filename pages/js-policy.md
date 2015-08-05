# Javascript policy

All of our JavaScript is free and open-source, so you don't have to
worry about enabling it.

Here is a list of all of the JavaScript we use:

<table class="table table-hover">
  <tr><th>Project     </th><th>Source URL                                 </th><th>LICENSE   </th></tr>
  <tr><td>Bootstrap   </td><td><https://github.com/twbs/bootstrap>        </td><td>MIT       </td></tr>
  <tr><td>highlight.js</td><td><https://github.com/isagalaev/highlight.js></td><td>FreeBSD   </td></tr>
  <tr><td>jQuery      </td><td><https://github.com/jquery/jquery>         </td><td>MIT       </td></tr>
  <tr><td>MathJax     </td><td><https://github.com/mathjax/MathJax>       </td><td>Apache 2.0</td></tr>
</table>

We also have two trivial lines of JavaScript of our own:

There is a dropdown menu on the header. The dropdown menu only works for
people with JavaScript. So, by default, instead of the dropdown menu, we
have two static links there that work without JavaScript.

This adds the dropdown menu at the top.

```javascript
document.write(`^{dropdownHtml}`)
```

This removes the static links:

```javascript
$(".noscript").remove()
```

Those who enable JavaScript only see the dropdown menu. Those who don't
only see the links.
