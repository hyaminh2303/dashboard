namespace :general_info do
  desc "add basic infor for Yoose"
  task create: :environment do
    OrderSetting.delete_all
    p = OrderSetting.new(key: 'logo', value: '', setting_type: 1)
    p.save! && puts('Added logo') if p.valid?

    p = OrderSetting.new(key: 'slogan', value: 'LOCATION-BASED ADVERTISING SOLUTIONS', setting_type: 1)
    p.save! && puts('Added slogan') if p.valid?

    p = OrderSetting.new(key: 'logo', value: '', setting_type: 1)
    p.save! && puts('Added logo') if p.valid?

    p = OrderSetting.new(key: 'address', value: '<p><strong>Singapore (Headquarter)</strong>
                                             </br>30A Duxton Road, Singapore 089494
                                             </br><strong>Germany</strong>
                                             </br>Friedrichstrasse 171, 10117 Berlin
                                             </br><strong>India</strong>
                                             </br>3rd Flr, N-116, Panchsheel Park, New
                                             </br>Delhi 110017
                                             </br><strong>USA</strong>
                                             </br>116 W 23rd Street, 5th floor, New York,
                                             </br>NY 10011</p>', setting_type: 1)
    p.save! && puts('Added address') if p.valid?

    p = OrderSetting.new(key: 'terms_and_conditions', value: '<p><strong>YOOSE Terms and Conditions</strong><br />
      Terms of Payment:</p>
      <ol>
        <li>For invoices USD 5,000 and under, YOOSE requires pre-payment before commencement of work</li>
        <li>For invoices between USD 5,001 and USD 10,000, 50% of the invoice as a deposit must be paid after terms of contract are agreed and at least 1 day prior to commencement of contract</li>
        <li>For invoices over USD 10,000 YOOSE will issue an invoice for payment the total amount reflected on this insertion Order at the end of each month or each campaign which ever come earlier, to be paid within 30 days of the date of that invoice.</li>
        <li>For invoices that are overdue after 30 days from date of issue, client may be charged an interest of 3% of outstanding fees.</li>
      </ol>
      <p><strong>Campaign Conditions</strong><br />
      All commercially reasonable efforts will be used to satisfy campaign conditions as stated within this IO. Client and YOOSE Pte. Ltd. agree that this IO can be terminated within 48hr after the mandatory activity period of five (5) operational days.</p>
      <p><strong>Ad Content Conditions</strong><br />
      Content is subject to YOOSE Pte. Ltd. approval and must comply with our terms of service and policies. YOOSE Pte. Ltd. reserves the right to not publish any Ad Content that is not in accordance with its terms of service and policies.<br />
      Each of the undersigned agrees to the campaign details as identified in this IO effective as of the last date signed below. Each person who signs below represents that he/she is duly authorized to sign on behalf of the undersigned.</p>
      <p style="text-align: center;"><strong>With exception to the specific terms and agreements listed above, this Insertion Order shall be governed by the IAB/AAAA&#39;s STANDARD TERMS AND CONDITIONS FOR INTERNET ADVERTISING FOR MEDIA BUYS ONE YEAR OR LESS.</strong></p>', setting_type: 1)
    p.save! && puts('Added terms_and_conditions') if p.valid?

    p = OrderSetting.new(key: 'authorization', value: '<p><strong>Please review and sign this order:</strong></p>
      <table border="1" cellpadding="1" cellspacing="1" style="width:100%">
        <tbody>
          <tr>
            <td style="width:70%">&nbsp;<strong>Name:&nbsp;</strong></td>
            <td><strong>&nbsp;Signature:</strong></td>
          </tr>
          <tr>
            <td style="width:30%">&nbsp;<strong>Position:</strong></td>
            <td><strong>&nbsp;Date:</strong></td>
          </tr>
        </tbody>
      </table>', setting_type: 1)
    p.save! && puts('Added authorization') if p.valid?

    SubTotalSetting.destroy_all
    st = SubTotalSetting.new(name: 'Banner & Landing Page Creation', value: 10, sub_total_setting_type: 0)
    st.save! if st.valid?
    st = SubTotalSetting.new(name: 'Media Budget', value: 5, sub_total_setting_type: 0)
    st.save! if st.valid?
    st = SubTotalSetting.new(name: 'Agency Commission', value: 15, sub_total_setting_type: 1)
    st.save! if st.valid?
    puts "====> Done"
  end

end
