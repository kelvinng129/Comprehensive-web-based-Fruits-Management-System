<%-- 
    Document   : dataTable.jsp
    Created on : 2025年4月19日, 上午10:06:13
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="table-responsive">
    <div class="table-actions mb-3">
        <div class="row align-items-center">
            <div class="col-md-6">
                <% if (request.getParameter("showSearch") != null && request.getParameter("showSearch").equals("true")) { %>
                <div class="search-box">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search..." onkeyup="filterTable()">
                    <i class="fas fa-search search-icon"></i>
                </div>
                <% } %>
            </div>
            <div class="col-md-6 text-right">
                <% if (request.getParameter("showExport") != null && request.getParameter("showExport").equals("true")) { %>
                <div class="dropdown d-inline-block">
                    <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="exportDropdown" data-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-download"></i> Export
                    </button>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="exportDropdown">
                        <a class="dropdown-item" href="#" onclick="exportTableToCSV('${param.exportFilename}.csv')"><i class="fas fa-file-csv mr-2"></i> CSV</a>
                        <a class="dropdown-item" href="#" onclick="exportTableToExcel('${param.exportFilename}.xlsx')"><i class="fas fa-file-excel mr-2"></i> Excel</a>
                        <a class="dropdown-item" href="#" onclick="printTable()"><i class="fas fa-print mr-2"></i> Print</a>
                    </div>
                </div>
                <% } %>
                
                <% if (request.getParameter("showAddButton") != null && request.getParameter("showAddButton").equals("true")) { %>
                <a href="${param.addButtonUrl}" class="btn btn-primary btn-sm ml-2">
                    <i class="fas fa-plus"></i> ${param.addButtonText}
                </a>
                <% } %>
            </div>
        </div>
    </div>
    
    <table class="table table-bordered table-striped" id="${param.tableId}">
        <thead class="bg-light">
            <tr>
                <c:forTokens items="${param.columns}" delims="," var="column">
                <th>${column}</th>
                </c:forTokens>
                
                <% if (request.getParameter("showActions") != null && request.getParameter("showActions").equals("true")) { %>
                <th class="text-center">Actions</th>
                <% } %>
            </tr>
        </thead>
        <tbody>
            <jsp:doBody/>
        </tbody>
    </table>
    
    <% if (request.getParameter("showPagination") != null && request.getParameter("showPagination").equals("true")) { %>
    <div class="pagination-container">
        <nav aria-label="Table navigation">
            <ul class="pagination justify-content-center">
                <li class="page-item disabled">
                    <a class="page-link" href="#" tabindex="-1" aria-disabled="true">Previous</a>
                </li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#">3</a></li>
                <li class="page-item">
                    <a class="page-link" href="#">Next</a>
                </li>
            </ul>
        </nav>
    </div>
    <% } %>
</div>

<script>
function filterTable() {
    var input, filter, table, tr, td, i, j, txtValue, found;
    input = document.getElementById("searchInput");
    filter = input.value.toUpperCase();
    table = document.getElementById("${param.tableId}");
    tr = table.getElementsByTagName("tr");
    
    for (i = 1; i < tr.length; i++) {
        found = false;
        td = tr[i].getElementsByTagName("td");
        
        for (j = 0; j < td.length; j++) {
            if (td[j]) {
                txtValue = td[j].textContent || td[j].innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    found = true;
                    break;
                }
            }
        }
        
        if (found) {
            tr[i].style.display = "";
        } else {
            tr[i].style.display = "none";
        }
    }
}

function exportTableToCSV(filename) {
    var csv = [];
    var rows = document.querySelectorAll('#${param.tableId} tr');
    
    for (var i = 0; i < rows.length; i++) {
        var row = [], cols = rows[i].querySelectorAll('td, th');
        
        for (var j = 0; j < cols.length; j++) {
            var text = cols[j].innerText.replace(/,/g, ' ');
            row.push('"' + text + '"');
        }
        
        csv.push(row.join(','));
    }
    
    // Download CSV
    downloadCSV(csv.join('\n'), filename);
}

function downloadCSV(csv, filename) {
    var csvFile;
    var downloadLink;
    
    csvFile = new Blob([csv], {type: 'text/csv'});
    
    downloadLink = document.createElement('a');
    
    downloadLink.download = filename;
    
    // Create link to file
    downloadLink.href = window.URL.createObjectURL(csvFile);
    
    downloadLink.style.display = 'none';
    
    document.body.appendChild(downloadLink);
    
    // Click download link
    downloadLink.click();
    
    // Remove link from DOM
    document.body.removeChild(downloadLink);
}

function printTable() {
    var printContents = document.getElementById('${param.tableId}').outerHTML;
    var originalContents = document.body.innerHTML;
    
    document.body.innerHTML = '<h1>${param.pageTitle}</h1>' + printContents;
    
    window.print();
    
    document.body.innerHTML = originalContents;
}
</script>
