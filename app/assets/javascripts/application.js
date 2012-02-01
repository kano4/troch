// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require pjax
$(document).ready(function() {
  var $tgt_parent = $("input.check-parent");
  var $tgt_child = $("input.check-child");

  $tgt_parent.click(function(){
    $(this).parents("div.parent").find('ul li input.check-child').attr('checked', this.checked);
  });

  $tgt_child.click(function(){
    var checkNum = $(this).parents('ul').find('li input.check-child:checked').length;
    var listNum = $(this).parents('ul').find('li').length;

    if(checkNum < listNum){
      $(this).parents("div.parent").find("input.check-parent:checkbox").removeAttr('checked');
    }

    if(checkNum == listNum){
      $(this).parents("div.parent").find("input.check-parent:checkbox").attr('checked','checked');
    }
  });
});
