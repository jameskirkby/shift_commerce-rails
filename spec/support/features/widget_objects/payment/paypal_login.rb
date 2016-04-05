module MyApp
  module Test
    module ComponentObject
      class PaypalLogin < CapybaraObjects::ComponentObject
        ctype "paypal_login"
        locator :css, "#loginModule", wait: 30

        def login!(email:, password:)
          email_node.set(email)
          password_node.set(password)
          submit_node.click
        end

        private

        def email_node
          scoped_find(:field, "login_email")
        end

        def password_node
          scoped_find(:field, "login_password")
        end

        def submit_node
          scoped_find(:css, "#submitLogin")
        end
      end
    end
  end
end

=begin
This is what the login module looks like
<div id="loginModule">
    <div id="hdrContainer" class="subhdr"><h2 id="loginPageTitle">Choose a way to pay</h2></div>
    <div class="panel active" id="method-paypal">
        <div class="top"></div>
        <div class="body clearfix">
            <div id="secureCheckout" class="lockLogo"><span class="spriteLogo paypallock" title="PayPal"></span></div>
            <span class="downarrow"></span>

            <div class="subhead" id="loginTitle">Pay with my PayPal account<span class="help">Log in to your account to complete the purchase</span>
            </div>
            <input type="hidden" name="email_recovery" value="false"><input type="hidden" name="password_recovery"
                                                                            value="false">

            <div id="loginBox"><p class="group"><label for="login_email"><span
                    class="labelText">Email</span></label><span class="field"><input type="text" id="login_email"
                                                                                     class="confidential large"
                                                                                     name="login_email" value=""></span>
            </p>

                <p class="group"><label for="login_password"><span class="labelText">PayPal password</span></label><span
                        class="field"><input autocomplete="off" type="password" id="login_password"
                                             name="login_password" value="" class="restricted large"></span></p>

                <p id="privateDevice"><input type="hidden" name="private_device_checkbox_flag" value="on"><input
                        type="checkbox" id="privateDeviceCheckbox" class="checkbox" name="private_device"
                        value="true"><label for="privateDeviceCheckbox">This is a private computer.</label><span
                        class="autoTooltip" id="privateDeviceTooltip" title="" tabindex="0">What's this?<span
                        class="accessAid">We remember your login details so you can check out more quickly. Please don't choose this option if you are using a public or shared computer.</span></span>
                </p>

                <p class="buttons"><input type="submit" id="submitLogin" name="login.x" value="Log In"
                                          class="button primary default parentSubmit"></p>

                <p>
                    <a href="https://www.sandbox.paypal.com/uk/cgi-bin/merchantpaymentweb?cmd=_account-recovery&amp;from=PayPal"
                       class="showPWInline">Forgotten your email address or password?</a></p>

                <div class="hide clearfix" id="account-recovery-help">
                    <div class="col1">
                        <ul>
                            <li>Step 1. Enter or recover your email address.</li>
                            <li>Step 2. Reset your password.</li>
                            <li>Step 3. Return and complete your payment.</li>
                        </ul>
                    </div>
                    <div class="col2"><a target="_blank"
                                         href="https://www.sandbox.paypal.com/uk/cgi-bin/merchantpaymentweb?cmd=_account-recovery&amp;from=PayPal">Start
                        now</a></div>
                </div>
                <p></p></div>
            <input type="hidden" id="pageSession" name="SESSION"
                   value="ZskL_-zeGGiMMD9ysQT8L3WQGqs2loTp_XVnl0d4giDdd8jGA4ddpopDqme"><input type="hidden"
                                                                                              id="pageDispatch"
                                                                                              name="dispatch"
                                                                                              value="50a222a57771920b6a3d7b606239e4d529b525e0b7e69bf0224adecfb0124e9b61f737ba21b081984719ecfa9a8ffe80733a1a700ced90ae"><input
                type="hidden" id="CONTEXT_CGI_VAR" name="CONTEXT"
                value="wtgSziM4C5x0SI-9CmKcv2vkSeTLK5P_g6HqzC__YTYkcqziFNcB84p79Ja"></div>
        <div class="bottom"></div>
    </div>
    <div id="method-cc" class="panel scTrack:xpt/Checkout/ec/Login::_express-checkout:ClickBilling"
         style="cursor: pointer;"><span class="rightarrow"></span>

        <div class="subhead"><span class="buttonAsLink"><input type="submit" value="Pay with a debit or credit card"
                                                               id="minipageSubmitBtn" name="new_user_button.x"
                                                               class="parentSubmit noMask noAnimation"></span>

            <p class="small secondary">(Optional) Sign up to PayPal to make your next checkout faster</p></div>
        <input type="hidden" name="cmd" value="_flow"><input type="hidden" name="id" value=""><input type="hidden"
                                                                                                     name="close_external_flow"
                                                                                                     value="false"><input
                type="hidden" name="external_close_account_payment_flow" value="payment_flow"></div>
</div>
=end