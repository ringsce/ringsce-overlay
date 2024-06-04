// Add initial coins to new users
function add_initial_coins_to_new_user($user_id) {
    add_user_meta($user_id, 'coins', 300, true);
}
add_action('user_register', 'add_initial_coins_to_new_user');

// Add coins field to user profile
function show_user_coins_in_profile($user) {
    $coins = get_user_meta($user->ID, 'coins', true);
    ?>
    <h3>Coins Balance</h3>
    <table class="form-table">
        <tr>
            <th><label for="coins">Coins</label></th>
            <td>
                <input type="text" name="coins" id="coins" value="<?php echo esc_attr($coins); ?>" class="regular-text" readonly /><br />
                <span class="description">This is the user's current coin balance.</span>
            </td>
        </tr>
    </table>
    <?php
}
add_action('show_user_profile', 'show_user_coins_in_profile');
add_action('edit_user_profile', 'show_user_coins_in_profile');

// Decrease coins for a user
function decrease_user_coins($user_id, $amount) {
    $current_coins = get_user_meta($user_id, 'coins', true);
    if ($current_coins >= $amount) {
        $new_coins = $current_coins - $amount;
        update_user_meta($user_id, 'coins', $new_coins);
        return true;
    } else {
        return false;
    }
}


// Unlock content with coins
function unlock_content_with_coins($content) {
    if (is_user_logged_in()) {
        $user_id = get_current_user_id();
        $coins = get_user_meta($user_id, 'coins', true);

        if (isset($_POST['unlock_content'])) {
            if ($coins >= 5) {
                if (decrease_user_coins($user_id, 5)) {
                    return $content;
                } else {
                    return 'Error: Unable to decrease coins.';
                }
            } else {
                return 'Not enough coins to unlock this content';
            }
        } else {
            return '
            <form method="post">
                <input type="submit" name="unlock_content" value="Unlock this content for 5 coins">
            </form>';
        }
    }

    return $content;
}
add_filter('the_content', 'unlock_content_with_coins');


// Enqueue scripts for the login form
add_action('login_enqueue_scripts', 'enqueue_custom_login_scripts');

function enqueue_custom_login_scripts() {
    if (!is_user_logged_in()) {
        wp_enqueue_script('jquery');
        wp_enqueue_script('custom-login-script', get_template_directory_uri() . '/js/custom-login-script.js', array('jquery'), '', true);
        wp_localize_script('custom-login-script', 'customLoginData', array(
            'ajax_url' => admin_url('admin-ajax.php'),
            'nonce' => wp_create_nonce('custom_send_2fa_code')
        ));
    }
}

// AJAX handler to send 2FA code
add_action('wp_ajax_nopriv_custom_send_2fa_code', 'custom_send_2fa_code');

function custom_send_2fa_code() {
    check_ajax_referer('custom_send_2fa_code', 'security');

    $user_login = sanitize_text_field($_POST['user_login']);
    $user = get_user_by('login', $user_login);

    if ($user) {
        $user_email = $user->user_email;
        $code = rand(100000, 999999);
        update_user_meta($user->ID, 'custom_2fa_code', $code);

        wp_mail($user_email, 'Your 2FA Code', 'Your 2FA code is: ' . $code);

        wp_send_json_success(array('message' => '2FA code sent to your email.'));
    } else {
        wp_send_json_error(array('message' => 'Invalid username.'));
    }

    wp_die();
}


// Display the 2FA code field on the login form
function custom_display_2fa_code_field() {
    if (!is_user_logged_in() && isset($_POST['log'])) {
        echo '
        <p>
            <label for="custom_2fa_code">2FA Code<br>
            <input type="text" name="custom_2fa_code" id="custom_2fa_code" class="input" value="" size="20"></label>
        </p>';
    }
}
add_action('login_form', 'custom_display_2fa_code_field');


// Verify 2FA code
add_filter('authenticate', 'custom_verify_2fa_code', 30, 3);

function custom_verify_2fa_code($user, $username, $password) {
    if (!is_wp_error($user) && isset($_POST['custom_2fa_code'])) {
        $entered_code = sanitize_text_field($_POST['custom_2fa_code']);
        $saved_code = get_user_meta($user->ID, 'custom_2fa_code', true);

        if ($entered_code !== $saved_code) {
            return new WP_Error('2fa_error', __('Invalid 2FA code.'));
        } else {
            delete_user_meta($user->ID, 'custom_2fa_code');
        }
    }

    return $user;
}


// Add initial coins to new users
function add_initial_coins_to_new_user($user_id) {
    add_user_meta($user_id, 'coins', 300, true);
}
add_action('user_register', 'add_initial_coins_to_new_user');

// Add coins field to user profile
function show_user_coins_in_profile($user) {
    $coins = get_user_meta($user->ID, 'coins', true);
    ?>
    <h3>Coins Balance</h3>
    <table class="form-table">
        <tr>
            <th><label for="coins">Coins</label></th>
            <td>
                <input type="text" name="coins" id="coins" value="<?php echo esc_attr($coins); ?>" class="regular-text" readonly /><br />
                <span class="description">This is the user's current coin balance.</span>
            </td>
        </tr>
    </table>
    <?php
}
add_action('show_user_profile', 'show_user_coins_in_profile');
add_action('edit_user_profile', 'show_user_coins_in_profile');

// Decrease coins for a user
function decrease_user_coins($user_id, $amount) {
    $current_coins = get_user_meta($user_id, 'coins', true);
    if ($current_coins >= $amount) {
        $new_coins = $current_coins - $amount;
        update_user_meta($user_id, 'coins', $new_coins);
        return true;
    } else {
        return false;
    }
}

// Unlock content with coins
function unlock_content_with_coins($content) {
    if (is_user_logged_in()) {
        $user_id = get_current_user_id();
        $coins = get_user_meta($user_id, 'coins', true);

        if (isset($_POST['unlock_content'])) {
            if ($coins >= 5) {
                if (decrease_user_coins($user_id, 5)) {
                    return $content;
                } else {
                    return 'Error: Unable to decrease coins.';
                }
            } else {
                return 'Not enough coins to unlock this content';
            }
        } else {
            return '
            <form method="post">
                <input type="submit" name="unlock_content" value="Unlock this content for 5 coins">
            </form>';
        }
    }

    return $content;
}
add_filter('the_content', 'unlock_content_with_coins');

// Enqueue scripts for the login form
add_action('login_enqueue_scripts', 'enqueue_custom_login_scripts');

function enqueue_custom_login_scripts() {
    if (!is_user_logged_in()) {
        wp_enqueue_script('jquery');
        wp_enqueue_script('custom-login-script', get_template_directory_uri() . '/js/custom-login-script.js', array('jquery'), '', true);
        wp_localize_script('custom-login-script', 'customLoginData', array(
            'ajax_url' => admin_url('admin-ajax.php'),
            'nonce' => wp_create_nonce('custom_send_2fa_code')
        ));
    }
}

// AJAX handler to send 2FA code
add_action('wp_ajax_nopriv_custom_send_2fa_code', 'custom_send_2fa_code');

function custom_send_2fa_code() {
    check_ajax_referer('custom_send_2fa_code', 'security');

    $user_login = sanitize_text_field($_POST['user_login']);
    $user = get_user_by('login', $user_login);

    if ($user) {
        $user_email = $user->user_email;
        $code = rand(100000, 999999);
        update_user_meta($user->ID, 'custom_2fa_code', $code);

        wp_mail($user_email, 'Your 2FA Code', 'Your 2FA code is: ' . $code);

        wp_send_json_success(array('message' => '2FA code sent to your email.'));
    } else {
        wp_send_json_error(array('message' => 'Invalid username.'));
    }

    wp_die();
}

// Display the 2FA code field on the login form
function custom_display_2fa_code_field() {
    if (!is_user_logged_in() && isset($_POST['log'])) {
        echo '
        <p>
            <label for="custom_2fa_code">2FA Code<br>
            <input type="text" name="custom_2fa_code" id="custom_2fa_code" class="input" value="" size="20"></label>
        </p>';
    }
}
add_action('login_form', 'custom_display_2fa_code_field');

// Verify 2FA code
add_filter('authenticate', 'custom_verify_2fa_code', 30, 3);

function custom_verify_2fa_code($user, $username, $password) {
    if (!is_wp_error($user) && isset($_POST['custom_2fa_code'])) {
        $entered_code = sanitize_text_field($_POST['custom_2fa_code']);
        $saved_code = get_user_meta($user->ID, 'custom_2fa_code', true);

        if ($entered_code !== $saved_code) {
            return new WP_Error('2fa_error', __('Invalid 2FA code.'));
        } else {
            delete_user_meta($user->ID, 'custom_2fa_code');
        }
    }

    return $user;
}
