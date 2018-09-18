function renderStats() {
  renderCharts()
  renderRunningRecord()
}

function renderRunningRecord() {
  var statData = document.getElementById('running-record-data')
  var data = JSON.parse(statData.dataset.data)


  var margin = {
    top: 20,
    right: 10,
    bottom: 20,
    left: 30
  }
  var highestRecord = Math.max.apply(null, data.map(Math.abs))

  var width = (25 * data.length) - margin.left - margin.right
  var height = (80 * highestRecord) - margin.top - margin.bottom


  var y = d3.scaleLinear()
    .domain([(highestRecord * -1), highestRecord])
    .range([height, 0]);

  var yAxis = d3.axisLeft(y);

  var xAxisScale = d3.scaleBand()
    .domain(Array(data.length).fill().map((_,i) => i+1))
    .range([ 0, width])
    .padding(0.1)

  var xAxis = d3.axisBottom(xAxisScale);

  var svg = d3.select("#running-record-data").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  svg.selectAll(".bar")
    .data(data)
    .enter().append("rect")
    .attr("class", function(d) {
      if (d < 0){
        return "bar negative";
      } else {
        return "bar positive";
      }
    })
    .attr("y", function(d) {
      if (d > 0){
        return y(d);
      } else {
        return y(0);
      }
    })
    .attr("x", function(d, i) {
      return xAxisScale(i + 1)
    })
    .attr("width", xAxisScale.bandwidth())
    .attr("height", function(d) {
      return Math.abs(y(d) - y(0));
    })

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);

  svg.append("g")
    .attr("class", "baseline")
    .append("line")
    .attr("y1", y(0))
    .attr("y2", y(0))
    .attr("x2", width);
}

function renderCharts() {
  var statData = document.getElementById('stat-data')
  var seasons = JSON.parse(statData.dataset.stats)

  seasons.forEach(function(season) {
    var width = 700;
    var height = 300;

    var omg = 50

    var svg = d3.select("svg.s" + season.name)
      .attr("width", width)
      .attr("height", height);

    var y = d3.scaleLinear()
      .domain([0, d3.max(season.pick_counts)])
      .range([0, (height - omg)])

    var x = d3.scaleBand()
      .domain(Array(17).fill().map((_,i) => i+1))
      .range([0, (width - 40)])
      .padding(0.1)

    var g = svg.append("g")
      .attr("transform", "translate(20,20)")
      .attr("class", "omg")

    g.append("g")
      .attr("class", "axis")
      .attr("transform", "translate(0," + (height - omg) + ")")
      .call(d3.axisBottom(x));

    var bar = g.selectAll(".new-bar")
      .data(season.pick_counts)
      .enter().append("g")
      .attr("class", "new-bar")
      .attr("transform", function(d, i) {
        var thisX = x(i + 1)
        var thisY = height - omg - y(d)
        return "translate(" + thisX + "," + thisY + ")"
      })

    bar.append("rect")
      .attr("width", x.bandwidth())
      .attr("height", function(d) {
        if (d > 0) {
          return y(d)
        } else {
          return 1
        }
      })
      .on("click", function(d, i) {
        var svg = this.closest('svg')
        var year = svg.classList[1].slice(1)
        var week = i + 1
        window.location = "/seasons/" + year + "/weeks/" + week
      })

    bar.append("text")
      .attr("class", function(d) {
        if (d > 1) {
          return "bar-label"
        } else {
          return "bar-label top"
        }
      })
      .attr("x", x.bandwidth() / 2)
      .attr("y", function(d) {
        if (d > 1) {
          return 16
        } else {
          return -8
        }
      })
      .text(function(d) { return d; });
  })
}
