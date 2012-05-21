<div class="vcard">
 <div class="name">
  % if len(email) > 0:
   <a href="mailto:${email}">${name}</a>
  % else:
   ${name}
  % endif
 </div>
 <div class="card">
  <a href="assets/${card}"><img src="assets/vcard.png"></a>
 </div>
</div>
