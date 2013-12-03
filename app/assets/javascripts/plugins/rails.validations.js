(function(){var e,t,n,r,i=[].indexOf||function(e){for(var t=0,n=this.length;t<n;t++){if(t in this&&this[t]===e)return t}return-1};e=jQuery;e.fn.disableClientSideValidations=function(){ClientSideValidations.disable(this);return this};e.fn.enableClientSideValidations=function(){this.filter(ClientSideValidations.selectors.forms).each(function(){return ClientSideValidations.enablers.form(this)});this.filter(ClientSideValidations.selectors.inputs).each(function(){return ClientSideValidations.enablers.input(this)});return this};e.fn.resetClientSideValidations=function(){this.filter(ClientSideValidations.selectors.forms).each(function(){return ClientSideValidations.reset(this)});return this};e.fn.validate=function(){this.filter(ClientSideValidations.selectors.forms).each(function(){return e(this).enableClientSideValidations()});return this};e.fn.isValid=function(i){var s;s=e(this[0]);if(s.is("form")){return n(s,i)}else{return t(s,r(this[0].name,i))}};r=function(e,t){e=e.replace(/_attributes\]\[\w+\]\[(\w+)\]/g,"_attributes][][$1]");return t[e]||{}};n=function(t,n){var r;t.trigger("form:validate:before.ClientSideValidations");r=true;t.find(ClientSideValidations.selectors.validate_inputs).each(function(){if(!e(this).isValid(n)){r=false}return true});if(r){t.trigger("form:validate:pass.ClientSideValidations")}else{t.trigger("form:validate:fail.ClientSideValidations")}t.trigger("form:validate:after.ClientSideValidations");return r};t=function(t,n){var r,i,s,o,u,a,f;t.trigger("element:validate:before.ClientSideValidations");a=function(){return t.trigger("element:validate:pass.ClientSideValidations").data("valid",null)};o=function(e){t.trigger("element:validate:fail.ClientSideValidations",e).data("valid",false);return false};r=function(){return t.trigger("element:validate:after.ClientSideValidations").data("valid")!==false};s=function(e){var r,i,s,u,a,f,l,c;u=true;for(i in e){r=e[i];if(n[i]){c=n[i];for(f=0,l=c.length;f<l;f++){a=c[f];if(s=r.call(e,t,a)){u=o(s);break}}if(!u){break}}}return u};i=t.attr("name").replace(/\[([^\]]*?)\]$/,"[_destroy]");if(e("input[name='"+i+"']").val()==="1"){a();return r()}if(t.data("changed")===false){return r()}t.data("changed",false);u=ClientSideValidations.validators.local;f=ClientSideValidations.validators.remote;if(s(u)&&s(f)){a()}return r()};if(window.ClientSideValidations===void 0){window.ClientSideValidations={}}if(window.ClientSideValidations.forms===void 0){window.ClientSideValidations.forms={}}window.ClientSideValidations.selectors={inputs:':input:not(button):not([type="submit"])[name]:visible:enabled',validate_inputs:":input:enabled:visible[data-validate]",forms:"form[data-validate]"};window.ClientSideValidations.reset=function(t){var n,r;n=e(t);ClientSideValidations.disable(t);for(r in t.ClientSideValidations.settings.validators){t.ClientSideValidations.removeError(n.find("[name='"+r+"']"))}return ClientSideValidations.enablers.form(t)};window.ClientSideValidations.disable=function(t){var n;n=e(t);n.off(".ClientSideValidations");if(n.is("form")){return ClientSideValidations.disable(n.find(":input"))}else{n.removeData("valid");n.removeData("changed");return n.filter(":input").each(function(){return e(this).removeAttr("data-validate")})}};window.ClientSideValidations.enablers={form:function(t){var n,r,i,s;n=e(t);t.ClientSideValidations={settings:window.ClientSideValidations.forms[n.attr("id")],addError:function(e,n){return ClientSideValidations.formBuilders[t.ClientSideValidations.settings.type].add(e,t.ClientSideValidations.settings,n)},removeError:function(e){return ClientSideValidations.formBuilders[t.ClientSideValidations.settings.type].remove(e,t.ClientSideValidations.settings)}};s={"submit.ClientSideValidations":function(e){if(!n.isValid(t.ClientSideValidations.settings.validators)){e.preventDefault();return e.stopImmediatePropagation()}},"ajax:beforeSend.ClientSideValidations":function(e){if(e.target===this){return n.isValid(t.ClientSideValidations.settings.validators)}},"form:validate:after.ClientSideValidations":function(e){return ClientSideValidations.callbacks.form.after(n,e)},"form:validate:before.ClientSideValidations":function(e){return ClientSideValidations.callbacks.form.before(n,e)},"form:validate:fail.ClientSideValidations":function(e){return ClientSideValidations.callbacks.form.fail(n,e)},"form:validate:pass.ClientSideValidations":function(e){return ClientSideValidations.callbacks.form.pass(n,e)}};for(i in s){r=s[i];n.on(i,r)}return n.find(ClientSideValidations.selectors.inputs).each(function(){return ClientSideValidations.enablers.input(this)})},input:function(t){var n,r,i,s,o,u;r=e(t);o=t.form;n=e(o);u={"focusout.ClientSideValidations":function(){return e(this).isValid(o.ClientSideValidations.settings.validators)},"change.ClientSideValidations":function(){return e(this).data("changed",true)},"element:validate:after.ClientSideValidations":function(t){return ClientSideValidations.callbacks.element.after(e(this),t)},"element:validate:before.ClientSideValidations":function(t){return ClientSideValidations.callbacks.element.before(e(this),t)},"element:validate:fail.ClientSideValidations":function(t,n){var r;r=e(this);return ClientSideValidations.callbacks.element.fail(r,n,function(){return o.ClientSideValidations.addError(r,n)},t)},"element:validate:pass.ClientSideValidations":function(t){var n;n=e(this);return ClientSideValidations.callbacks.element.pass(n,function(){return o.ClientSideValidations.removeError(n)},t)}};for(s in u){i=u[s];r.filter(":not(:radio):not([id$=_confirmation])").each(function(){return e(this).attr("data-validate",true)}).on(s,i)}r.filter(":checkbox").on("click.ClientSideValidations",function(){e(this).isValid(o.ClientSideValidations.settings.validators);return true});return r.filter("[id$=_confirmation]").each(function(){var t,r,u,a;t=e(this);r=n.find("#"+this.id.match(/(.+)_confirmation/)[1]+":input");if(r[0]){u={"focusout.ClientSideValidations":function(){return r.data("changed",true).isValid(o.ClientSideValidations.settings.validators)},"keyup.ClientSideValidations":function(){return r.data("changed",true).isValid(o.ClientSideValidations.settings.validators)}};a=[];for(s in u){i=u[s];a.push(e("#"+t.attr("id")).on(s,i))}return a}})}};window.ClientSideValidations.validators={all:function(){return jQuery.extend({},ClientSideValidations.validators.local,ClientSideValidations.validators.remote)},local:{presence:function(e,t){if(/^\s*$/.test(e.val()||"")){return t.message}},acceptance:function(e,t){var n;switch(e.attr("type")){case"checkbox":if(!e.prop("checked")){return t.message}break;case"text":if(e.val()!==(((n=t.accept)!=null?n.toString():void 0)||"1")){return t.message}}},format:function(e,t){var n;n=this.presence(e,t);if(n){if(t.allow_blank===true){return}return n}if(t["with"]&&!t["with"].test(e.val())){return t.message}if(t.without&&t.without.test(e.val())){return t.message}},numericality:function(t,n){var r,i,s,o,u,a,f;f=jQuery.trim(t.val());if(!ClientSideValidations.patterns.numericality.test(f)){if(n.allow_blank===true&&this.presence(t,{message:n.messages.numericality})){return}return n.messages.numericality}f=f.replace(new RegExp("\\"+ClientSideValidations.number_format.delimiter,"g"),"").replace(new RegExp("\\"+ClientSideValidations.number_format.separator,"g"),".");if(n.only_integer&&!/^[+-]?\d+$/.test(f)){return n.messages.only_integer}r={greater_than:">",greater_than_or_equal_to:">=",equal_to:"==",less_than:"<",less_than_or_equal_to:"<="};u=e(t[0].form);for(i in r){a=r[i];if(!(n[i]!=null)){continue}if(!isNaN(parseFloat(n[i]))&&isFinite(n[i])){s=n[i]}else if(u.find("[name*="+n[i]+"]").size()===1){s=u.find("[name*="+n[i]+"]").val()}else{return}o=new Function("return "+f+" "+a+" "+s);if(!o()){return n.messages[i]}}if(n.odd&&!(parseInt(f,10)%2)){return n.messages.odd}if(n.even&&parseInt(f,10)%2){return n.messages.even}},length:function(e,t){var n,r,i,s,o,u,a,f;f=t.js_tokenizer||"split('')";a=(new Function("element","return (element.val()."+f+" || '').length"))(e);n={is:"==",minimum:">=",maximum:"<="};r={};r.message=t.is?t.messages.is:t.minimum?t.messages.minimum:void 0;o=this.presence(e,r);if(o){if(t.allow_blank===true){return}return o}for(i in n){u=n[i];if(!t[i]){continue}s=new Function("return "+a+" "+u+" "+t[i]);if(!s()){return t.messages[i]}}},exclusion:function(e,t){var n,r,s,o,u;r=this.presence(e,t);if(r){if(t.allow_blank===true){return}return r}if(t["in"]){if(u=e.val(),i.call(function(){var e,n,r,i;r=t["in"];i=[];for(e=0,n=r.length;e<n;e++){s=r[e];i.push(s.toString())}return i}(),u)>=0){return t.message}}if(t.range){n=t.range[0];o=t.range[1];if(e.val()>=n&&e.val()<=o){return t.message}}},inclusion:function(e,t){var n,r,s,o,u;r=this.presence(e,t);if(r){if(t.allow_blank===true){return}return r}if(t["in"]){if(u=e.val(),i.call(function(){var e,n,r,i;r=t["in"];i=[];for(e=0,n=r.length;e<n;e++){s=r[e];i.push(s.toString())}return i}(),u)>=0){return}return t.message}if(t.range){n=t.range[0];o=t.range[1];if(e.val()>=n&&e.val()<=o){return}return t.message}},confirmation:function(e,t){var n=jQuery("#"+e.attr("id")+"_confirmation").val();if(n.length>0){if(n!==jQuery("#"+"user_password").val()){return t.message}}},uniqueness:function(t,n){var r,i,s,o,u,a,f;s=t.attr("name");if(/_attributes\]\[\d/.test(s)){i=s.match(/^(.+_attributes\])\[\d+\](.+)$/);o=i[1];u=i[2];f=t.val();if(o&&u){r=t.closest("form");a=true;r.find(':input[name^="'+o+'"][name$="'+u+'"]').each(function(){if(e(this).attr("name")!==s){if(e(this).val()===f){a=false;return e(this).data("notLocallyUnique",true)}else{if(e(this).data("notLocallyUnique")){return e(this).removeData("notLocallyUnique").data("changed",true)}}}});if(!a){return n.message}}}}},remote:{uniqueness:function(e,t){var n,r,i,s,o,u,a,f;i=ClientSideValidations.validators.local.presence(e,t);if(i){if(t.allow_blank===true){return}return i}n={};n.case_sensitive=!!t.case_sensitive;if(t.id){n.id=t.id}if(t.scope){n.scope={};f=t.scope;for(r in f){o=f[r];a=e.attr("name").replace(/\[\w+\]$/,"["+r+"]");u=jQuery("[name='"+a+"']");jQuery("[name='"+a+"']:checkbox").each(function(){if(this.checked){return u=this}});if(u[0]&&u.val()!==o){n.scope[r]=u.val();u.unbind("change."+e.id).bind("change."+e.id,function(){e.trigger("change.ClientSideValidations");return e.trigger("focusout.ClientSideValidations")})}else{n.scope[r]=o}}}if(/_attributes\]/.test(e.attr("name"))){s=e.attr("name").match(/\[\w+_attributes\]/g).pop().match(/\[(\w+)_attributes\]/).pop();s+=/(\[\w+\])$/.exec(e.attr("name"))[1]}else{s=e.attr("name")}if(t["class"]){s=t["class"]+"["+s.split("[")[1]}n[s]=e.val();if(jQuery.ajax({url:ClientSideValidations.remote_validators_url_for("uniqueness"),data:n,async:false,cache:false}).status===200){return t.message}}}};window.ClientSideValidations.remote_validators_url_for=function(e){if(ClientSideValidations.remote_validators_prefix!=null){return"//"+window.location.host+"/"+ClientSideValidations.remote_validators_prefix+"/validators/"+e}else{return"//"+window.location.host+"/validators/"+e}};window.ClientSideValidations.disableValidators=function(){var e,t,n,r;if(window.ClientSideValidations.disabled_validators===void 0){return}n=window.ClientSideValidations.validators.remote;r=[];for(t in n){e=n[t]}return r};window.ClientSideValidations.formBuilders={"ActionView::Helpers::FormBuilder":{add:function(t,n,r){var i,s,o,u;i=e(t[0].form);if(t.data("valid")!==false&&!(i.find("label.message[for='"+t.attr("id")+"']")[0]!=null)){s=jQuery(n.input_tag);u=jQuery(n.label_tag);o=i.find("label[for='"+t.attr("id")+"']:not(.message)");if(t.attr("autofocus")){t.attr("autofocus",false)}t.before(s);s.find("span#input_tag").replaceWith(t);s.find("label.message").attr("for",t.attr("id"));u.find("label.message").attr("for",t.attr("id"));u.insertAfter(o);u.find("label#label_tag").replaceWith(o)}return i.find("label.message[for='"+t.attr("id")+"']").text(r)},remove:function(t,n){var r,i,s,o,u;i=e(t[0].form);r=jQuery(n.input_tag).attr("class");s=t.closest("."+r.replace(" ","."));o=i.find("label[for='"+t.attr("id")+"']:not(.message)");u=o.closest("."+r);if(s[0]){s.find("#"+t.attr("id")).detach();s.replaceWith(t);o.detach();return u.replaceWith(o)}}}};window.ClientSideValidations.patterns={numericality:/^(-|\+)?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d*)?$/};window.ClientSideValidations.callbacks={element:{after:function(e,t){},before:function(e,t){},fail:function(e,t,n,r){return n()},pass:function(e,t,n){return t()}},form:{after:function(e,t){},before:function(e,t){},fail:function(e,t){},pass:function(e,t){}}};e(function(){ClientSideValidations.disableValidators();return e(ClientSideValidations.selectors.forms).validate()})}).call(this)