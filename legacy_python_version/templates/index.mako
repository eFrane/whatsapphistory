<%include file="header.mako" />
  <h1>WhatsApp Chat History</h1>
  <a href="full.htm">View complete History in one file.</a>
  <div id="calendar">
   % for month in months:
     <div class="month" id="month-${month.name}">
      <h2><a href="months/month-${month.name}.htm">${month.name}</a></h2>
      <ul>
       % for day in month.days:
         <li><a href="days/day-${day.number}.htm">${day.number}</a></li>
       % endfor
      </ul>
     </div>
   % endfor
  </div>
  <a href="full.htm">View complete History in one file.</a>
<%include file="footer.mako" />
