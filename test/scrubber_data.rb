MARKUP = <<-EOS
<p>Some <b>bold junk</b> here...</p>
<p>Some more junk <i>here...</i><br></p>
<p>Still more junk <u>here</u>... </p>
<p><img title="nothing to see here" alt="nothing to see here" mce_src="http://example.com/imgtest.png" src="http://example.com/imgtest.png" align="middle" border="1" height="240" hspace="5" vspace="5" width="320">&nbsp;</p>
<p>&nbsp;And a <a title="Just a link" target="_blank" mce_href="http://example.com/nothing.html" href="http://example.com/nothing.html">link</a> just because</p>
<p><div>some stuff in here</div><img title="nothing to see here" alt="nothing to see here" mce_src="http://example.com/imgtest.png" src="http://example.com/imgtest.png" align="middle" border="1" height="240" hspace="5" vspace="5" width="320"></p>
<a name="junk"></a>
<p><script type="text/javascript">//nasty bits go here
alert("gotcha");</script><img src="http://content.example.com/content/3587a2f6ee641074fec4e7534c01655326c218ec">how about an <a href="javascript:alert('gotcha')">inline script</a>
</p>
<span>some random unclosed span
<style type="text/css">.foo {color:blue}</style>
EOS
