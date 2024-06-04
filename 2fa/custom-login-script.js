jQuery(document).ready(function($) {
    $('#loginform').on('submit', function(e) {
        e.preventDefault();
        
        var user_login = $('#user_login').val();

        $.ajax({
            type: 'POST',
            url: customLoginData.ajax_url,
            data: {
                action: 'custom_send_2fa_code',
                user_login: user_login,
                security: customLoginData.nonce
            },
            success: function(response) {
                if (response.success) {
                    alert(response.data.message);
                    $('#loginform').off('submit').submit();
                } else {
                    alert(response.data.message);
                }
            }
        });
    });
});
