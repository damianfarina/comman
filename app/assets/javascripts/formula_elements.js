Comman.namespace("factory_formula_elements");
Comman.factory_formula_elements.index = function() {
  var init = function() {
    setupJoinButton();
    // setupCharts();

    var $inputs = $("#formula_elements_list input[type=checkbox]");
    var $join_button = $('#join_formula_elements_button');
    $inputs.change(setupJoinButton);
    $join_button.click(collectElementsToJoin);
  }

  var setupCharts = function() {
    $('.chart-container').each(function(){
      $container = $(this);
      setupChart($container);
    })
  }

  var collectElementsToJoin = function() {
    var formula_element_ids = [];
    $("#formula_elements_list input:checked").each(function(index, element){
      formula_element_ids.push($(element).data().elementId);
    });
    $(this).attr('href', $(this).attr('href') + "?formula_element_ids=" + formula_element_ids.join(','));
    return true;
  }

  var setupJoinButton = function() {
    var $join_button = $('#join_formula_elements_button');
    var $checkboxes = $("#formula_elements_list input:checked");
    if($checkboxes.size() >= 2) {
      $join_button.closest('li').fadeIn('fast');
    } else {
      $join_button.closest('li').fadeOut('fast');
    }
  }

  var setupChart = function($container) {
    debugger
    chart = new Highcharts.Chart({
      chart: {
        renderTo: $container.attr("id"),
        type: 'bar'
      },
      legend: {
        enabled: false
      },
      title: {
        text: null
      },
      xAxis: {
        categories: [$container.data().formulaElementName],
        title: {
          text: null
        },
        labels: {
          enabled: false
        }
      },
      yAxis: {
        min: 0,
        max: 100,
        title: {
          text: null
        },
        labels: {
          enabled: false
        }
      },
      tooltip: {
        formatter: function() {
          return ''+
          this.series.name +': '+ this.y +'kg';
        }
      },
      credits: {
        enabled: false
      },
      series: [{
        name: $container.data().formulaElementStockLabel,
        data: [$container.data().formulaElementStockPercentage]
      }]
    });
  }

  return {
    init: init
  }
}()