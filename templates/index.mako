<!DOCTYPE html>
<!--
#  WhatsApp History
#  Copyright (C) 2010, Stefan Graupner
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->
<html>
 <head>
  <title>WhatsApp Chat History</title>
 </head>
 <body>
  <h1>WhatsApp Chat History</h1>
  <a href="full.htm">View complete History in one file.</a>
  <div id="calendar">
   % for month in months:
     <div class="month" id="month-${month}">
      <h2><a href="months/month-${month}.htm">${month}</a></h2>
      <ul>
       % for day in month:
         <li><a href="days/day-${day}.htm">${day}</a>
       % endfor
      </ul>
     </div>
   % endfor
  </div>
  <a href="full.htm">View complete History in one file.</a>
  <footer>
   Generated with <a href="http://github.com/eFrane/whatsapphistory">whatsapphistory.py</a>
   ${version} on ${builddate}
  </footer>
 </body>
</html>
