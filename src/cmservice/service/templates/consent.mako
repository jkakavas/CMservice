<%!
    def list2str(claim):
        # more human-friendly and avoid "u'" prefix for unicode strings in list
        if isinstance(claim, list):
            claim = ", ".join(claim)
        if claim.startswith('['):
            claim = claim[1:]
        if claim.startswith('\''):
            claim = claim[1:]
        if claim.endswith(']'):
            claim = claim[:-1]
        if claim.endswith('\''):
            claim = claim[:-1]
        return claim
%>

<%inherit file="base.mako"/>

<%block name="head_title">${_("Consent")}</%block>
<%block name="page_header">${_("Your consent is required to continue.")}</%block>
<%block name="extra_inputs">
    <input type="hidden" name="state" value="${ state }">
</%block>
<div class="row">
  <div class="col-md-10">
      ${_("This description will explain to the academic user what is going on and what information we will share with ${requester_name}.")}
  </div>
  <div class="col-md-2 aligh-right sp-col-2">
      % if requester_logo:
      <img id="requester_logo" class="requester_logo" src="${requester_logo}"/>
      % endif
  </div>
</div>
<div class="row clearfix"><br/></div>
<div class="row clearfix"><br/></div>
<div class="panel-group">
    <div class="panel panel-default">
        <div class="panel-heading">
            <a data-toggle="collapse" data-target="#attributeDetails" aria-expanded="false" aria-controls="attributeDetails"><h4 class="panel-title">${_("Details")}</h4></a>
        </div>
        <div class="panel-collapse collapse" id="attributeDetails">
             <ul class="list-group">
             % for attribute in released_claims:
                 <li class="list-group-item"><span>${_(attribute).capitalize()}</span>:&nbsp;
                 <span>${released_claims[attribute] | list2str}</span></li>
             % endfor
             </ul>
        </div>
    </div>
</div>
    <div class="row"><hr/></div>

    <div class="row clearfix"><br/></div>
    <div class="btn-block">
    <form name="allow_consent" id="allow_consent_form" action="/save_consent" method="GET">
      <input name="Yes" value="${_('OK, accept')}" id="submit_ok"
             type="submit" class="btn btn-primary">
      <input name="No" value="${_('No, cancel')}" id="submit_deny"
             type="submit" class="btn btn-warning">
      <input type="hidden" id="attributes" name="attributes"/>
      <input type="hidden" id="consent_status" name="consent_status"/>
      ${extra_inputs()}
    </form>
    </div>
</div>

<script>
    $('input:checked').each(function () {
        if (!${select_attributes.lower()}) {
            $(this).removeAttr("checked")
        }
    });

    $('#allow_consent_form').submit(function (ev) {
        ev.preventDefault(); // to stop the form from submitting

        var attributes = [];
        $('input:checked').each(function () {
            attributes.push(this.name);
        });

        var consent_status = $('#consent_status');

        var status = $("input[type=submit][clicked=true]").attr("name");
        consent_status.val(status);

        if (attributes.length == 0) {
            consent_status.val("No");
            alert("${_('No attributes where selected which equals no consent where given')}");
        }

        % for attr in locked_claims:
            attributes.push("${attr}");
        % endfor
        $('#attributes').val(attributes);

        this.submit(); // If all the validations succeeded
    });

    $("form input[type=submit]").click(function () {
        $("input[type=submit]", $(this).parents("form")).removeAttr("clicked");
        $(this).attr("clicked", "true");
    });
</script>
