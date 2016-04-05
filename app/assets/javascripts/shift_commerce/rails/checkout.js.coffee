getAllowEditSection = (scope) ->
  checkBoxName = "allow_edit_#{scope.replace('checkout_', '')}"
  $("*[data-behavior='checkout_view'] *[data-behavior='address'] *[data-action='#{checkBoxName}']")
$(document).on 'ready page:load', (event) ->
  # If JS is not enabled, at least these checkboxes will stay visible, otherwise their
  # hidden state is represented by whether the user is using their own address or one from
  # an address book.
  getAllowEditSection("checkout_shipping_address")?.hide()
  getAllowEditSection("checkout_billing_address")?.hide()
  $("*[data-behavior='checkout_view'] *[data-behavior='address'] *[data-action='select_saved_address']").on 'change', (event) ->
    if this.value == ""
      scope = this.attributes['data-scope'].value
      $("*[data-behavior='#{scope}'] *[data-address-field]").val("").prop('disabled', false)
      getAllowEditSection(scope)?.hide()
    else
      $.ajax "/account/addresses/#{this.value}.json",
        success: (wrapper, status, jqXHR) =>
          getAllowEditSection(this.attributes['data-scope'].value)?.show()?.find("input[type='checkbox']").attr('checked', false)
          $.each wrapper.data.attributes, (attr, value) =>
            $("*[data-behavior='#{this.attributes['data-scope'].value}'] *[name$='[#{attr}]']").val(value).prop('disabled', true)


        error: (jqXHR, status, error) ->
          # In a production application, this would need to be done properly not just an alert
          alert("An error occured of type '#{status}' - desription '#{error}'")
  $("*[data-behavior='checkout_view'] *[data-behavior='address'] *[name='cart[allow_edit_billing_address]']").on 'change', (event) ->
    disabled = !this.checked
    $("*[data-behavior='checkout_billing_address'] *[data-address-field]").prop('disabled', disabled)
  $("*[data-behavior='checkout_view'] *[data-behavior='address'] *[name='cart[allow_edit_shipping_address]']").on 'change', (event) ->
    disabled = !this.checked
    $("*[data-behavior='checkout_shipping_address'] *[data-address-field]").prop('disabled', disabled)
