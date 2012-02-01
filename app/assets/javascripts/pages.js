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

$(document).ready(function() {
  var checkNum = $("input.check-child:checked").parents('ul').find('li input.check-child:checked').length;
  var listNum = $("input.check-child:checked").parents('ul').find('li').length;
  var parentList = document.querySelectorAll('div.parent');
  var parentNum  = parentList.length;
  for (var i = 0; i < parentNum; i++) {
    var childList = parentList[i].querySelectorAll('li input.check-child');
    var childNum = childList.length;
    var checked = parentList[i].querySelectorAll('li input.check-child:checked');
    var checkedNum = checked.length;

    if(childNum == checkedNum && childNum > 0){
      $(parentList[i]).find("input.check-parent:checkbox").attr('checked','checked');
    }
  }
});
