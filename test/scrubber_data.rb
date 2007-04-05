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

GOOGLE = <<-EOS
<html><head><meta http-equiv="content-type" content="text/html; charset=ISO-8859-1"><title>Google</title><style><!--
body,td,a,p,.h{font-family:arial,sans-serif}
.h{font-size:20px}
.h{color:#3366cc}
.q{color:#00c}
--></style>
<script>
<!--
function sf(){document.f.q.focus();}
// -->
</script>
</head><body bgcolor=#ffffff text=#000000 link=#0000cc vlink=#551a8b alink=#ff0000 onload="sf();if(document.images){new Image().src='/images/nav_logo2.png'}" topmargin=3 marginheight=3><center><div align=right nowrap style="padding-bottom:4px" width=100%><font size=-1><a href="/url?sa=p&pref=ig&pval=3&q=http://www.google.com/ig%3Fhl%3Den&usg=__yvmOvIrk79QYmDkrJAeuYO8jTmo=">Personalize this page</a>&nbsp;|&nbsp;<a href="https://www.google.com/accounts/Login?continue=http://www.google.com/&hl=en">Sign in</a></font></div><img alt="Google" height=110 src="/intl/en_ALL/images/logo.gif" width=276><br><br><form action="/search" name=f><script defer><!--
function togDisp(e){stopB(e);var elems=document.getElementsByName('more');for(var i=0;i<elems.length;i++){var obj=elems[i],dp="";if(obj.style.display==""){dp="none";}obj.style.display=dp;}return false;}
function stopB(e){if(!e)e=window.event;e.cancelBubble=true;}
document.onclick=function(event){var elems=document.getElementsByName('more');if(elems[0].style.display==""){togDisp(event);}}
//-->
</script><table border=0 cellspacing=0 cellpadding=4><tr><td nowrap><font size=-1><b>Web</b>&nbsp;&nbsp;&nbsp;&nbsp;<a class=q href="http://images.google.com/imghp?ie=ISO-8859-1&oe=ISO-8859-1&hl=en&tab=wi">Images</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class=q href="http://video.google.com/?ie=ISO-8859-1&oe=ISO-8859-1&hl=en&tab=wv">Video</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class=q href="http://news.google.com/nwshp?ie=ISO-8859-1&oe=ISO-8859-1&hl=en&tab=wn">News</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class=q href="http://maps.google.com/maps?ie=ISO-8859-1&oe=ISO-8859-1&hl=en&tab=wl">Maps</a>&nbsp;&nbsp;&nbsp;&nbsp;<b><a href="/intl/en/options/" class=q onclick="this.blur();return togDisp(event)">more&nbsp;&raquo;</a></b><span name=more id=more style="display:none;position:absolute;background:#fff;border:1px solid #369;margin:-.5ex 2ex;padding:0 0 .5ex .8ex;width:16ex;line-height:1.9;z-index:1000" onclick="stopB(event)"><a href=# onclick="return togDisp(event)"><img border=0 src=/images/x2.gif width=12 height=12 alt="Close menu" align=right hspace=4 vspace=4></a><a class=q href="http://blogsearch.google.com/?ie=ISO-8859-1&oe=ISO-8859-1&hl=en&tab=wb">Blogs</a><br><a class=q href="http://books.google.com/bkshp?ie=ISO-8859-1&oe=ISO-8859-1&hl=en&tab=wp">Books</a><br><a class=q href="http://froogle.google.com/frghp?ie=ISO-8859-1&oe=ISO-8859-1&hl=en&tab=wf">Froogle</a><br><a class=q href="http://groups.google.com/grphp?ie=ISO-8859-1&oe=ISO-8859-1&hl=en&tab=wg">Groups</a><br><a class=q href="http://www.google.com/ptshp?ie=ISO-8859-1&oe=ISO-8859-1&hl=en&tab=wt">Patents</a><br><a href="/intl/en/options/" class=q><b>even more &raquo;</b></a></span></font></td></tr></table><table cellpadding=0 cellspacing=0><tr valign=top><td width=25%>&nbsp;</td><td align=center nowrap><input name=hl type=hidden value=en><input type=hidden name=ie value="ISO-8859-1"><input maxlength=2048 name=q size=55 title="Google Search" value=""><br><input name=btnG type=submit value="Google Search"><input name=btnI type=submit value="I'm Feeling Lucky"></td><td nowrap width=25%><font size=-2>&nbsp;&nbsp;<a href=/advanced_search?hl=en>Advanced Search</a><br>&nbsp;&nbsp;<a href=/preferences?hl=en>Preferences</a><br>&nbsp;&nbsp;<a href=/language_tools?hl=en>Language Tools</a></font></td></tr></table></form><br><br><font size=-1><a href="/intl/en/ads/">Advertising&nbsp;Programs</a> - <a href="/services/">Business Solutions</a> - <a href=/intl/en/about.html>About Google</a></font><p><font size=-2>&copy;2007 Google</font></p></center></body></html>
EOS