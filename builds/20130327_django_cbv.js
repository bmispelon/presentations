(function () {
    var tables = document.getElementsByClassName('history');
    var cells;
    for (var i=0; i<tables.length; i++) {
        cells = tables[i].getElementsByTagName('td');
        for (var j=0; j<cells.length; j++) {
            switch (cells[j].innerHTML.trim()) {
                case "☀":
                    cells[j].className = 'yes';
                    break;
                case '☁':
                    cells[j].className = 'no';
                    break;
                case '☂':
                    cells[j].className = 'deprecated';
                    break;
            }
        }
    }
})();

