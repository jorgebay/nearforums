﻿/*
Copyright (c) 2003-2009, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.skins.add('kama',(function(){var a=[],b='cke_ui_color';if(CKEDITOR.env.ie&&CKEDITOR.env.version<7)a.push('icons.png','images/sprites_ie6.png','images/dialog_sides.gif');return{preload:a,editor:{css:['editor.css']},dialog:{css:['dialog.css']},templates:{css:['templates.css']},margins:[0,0,0,0],init:function(c){if(c.config.width&&!isNaN(c.config.width))c.config.width-=12;var d=[],e=/\$color/g,f='/* UI Color Support */.cke_skin_kama .cke_menuitem .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuitem a:hover .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a:focus .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a:active .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuitem a:hover .cke_label,.cke_skin_kama .cke_menuitem a:focus .cke_label,.cke_skin_kama .cke_menuitem a:active .cke_label{\tbackground-color: $color !important;}.cke_skin_kama .cke_menuitem a.cke_disabled:hover .cke_label,.cke_skin_kama .cke_menuitem a.cke_disabled:focus .cke_label,.cke_skin_kama .cke_menuitem a.cke_disabled:active .cke_label{\tbackground-color: transparent !important;}.cke_skin_kama .cke_menuitem a.cke_disabled:hover .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a.cke_disabled:focus .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a.cke_disabled:active .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuitem a.cke_disabled .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuseparator{\tbackground-color: $color !important;}.cke_skin_kama .cke_menuitem a:hover,.cke_skin_kama .cke_menuitem a:focus,.cke_skin_kama .cke_menuitem a:active{\tbackground-color: $color !important;}';if(CKEDITOR.env.webkit){f=f.split('}').slice(0,-1);for(var g=0;g<f.length;g++)f[g]=f[g].split('{');}function h(k){var l=k.getById(b);if(!l){l=k.getHead().append('style');l.setAttribute('id',b);l.setAttribute('type','text/css');}return l;};function i(k,l,m){var n,o,p;for(var q=0;q<k.length;q++){if(CKEDITOR.env.webkit)for(o=0;o<l.length;o++){p=l[o][1];for(n=0;n<m.length;n++)p=p.replace(m[n][0],m[n][1]);k[q].$.sheet.addRule(l[o][0],p);}else{p=l;for(n=0;n<m.length;n++)p=p.replace(m[n][0],m[n][1]);if(CKEDITOR.env.ie)k[q].$.styleSheet.cssText+=p;else k[q].$.innerHTML+=p;}}};var j=/\$color/g;CKEDITOR.tools.extend(c,{uiColor:null,getUiColor:function(){return this.uiColor;
},setUiColor:function(k){var l,m=h(CKEDITOR.document),n='#cke_'+CKEDITOR.tools.escapeCssSelector(c.name),o=[n+' .cke_wrapper',n+'_dialog .cke_dialog_contents',n+'_dialog a.cke_dialog_tab',n+'_dialog .cke_dialog_footer'].join(','),p='background-color: $color !important;';if(CKEDITOR.env.webkit)l=[[o,p]];else l=o+'{'+p+'}';return(this.setUiColor=function(q){var r=[[j,q]];c.uiColor=q;i([m],l,r);i(d,f,r);})(k);}});c.on('menuShow',function(k){var l=k.data[0],m=l.element.getElementsByTag('iframe').getItem(0).getFrameDocument();if(!m.getById('cke_ui_color')){var n=h(m);d.push(n);var o=c.getUiColor();if(o)i([n],f,[[j,o]]);}});if(c.config.uiColor)c.setUiColor(c.config.uiColor);}};})());if(CKEDITOR.dialog)CKEDITOR.dialog.on('resize',function(a){var b=a.data,c=b.width,d=b.height,e=b.dialog,f=e.parts.contents;if(b.skin!='kama')return;f.setStyles({width:c+'px',height:d+'px'});setTimeout(function(){var g=e.parts.dialog.getChild([0,0,0]),h=g.getChild(0),i=g.getChild(2);i.setStyle('width',h.$.offsetWidth+'px');i=g.getChild(7);i.setStyle('width',h.$.offsetWidth-28+'px');i=g.getChild(4);i.setStyle('height',h.$.offsetHeight-31-14+'px');i=g.getChild(5);i.setStyle('height',h.$.offsetHeight-31-14+'px');},100);});
