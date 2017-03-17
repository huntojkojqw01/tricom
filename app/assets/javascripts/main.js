
var ready = function () {

    /**
     * When the send message link on our home page is clicked
     * send an ajax request to our rails app with the sender_id and
     * recipient_id
     */
    $(document).on('click', '.start-conversation', function(e) {
        e.preventDefault();

        var sender_id = $(this).data('sid');
        var recipient_id = $(this).data('rip');

        $.post("/conversations", { sender_id: sender_id, recipient_id: recipient_id }, function (data) {

            chatBox.chatWith(data.conversation_id);
        });
    });

    /**
     * Used to minimize the chatbox
     */

    $(document).on('click', '.toggleChatBox', function (e) {
        e.preventDefault();

        var id = $(this).data('cid');
        chatBox.toggleChatBoxGrowth(id);
    });

    /**
     * Used to close the chatbox
     */

    $(document).on('click', '.closeChat', function (e) {
        e.preventDefault();

        var id = $(this).data('cid');
        chatBox.close(id);
    });


    /**
     * Listen on keypress' in our chat textarea and call the
     * chatInputKey in chat.js for inspection
     */

    $(document).on('keydown', '.chatboxtextarea', function (event) {
        var id = $(this).data('cid');
        chatBox.checkInputKey(event, $(this), id);
    });

    /**
     * When a conversation link is clicked show up the respective
     * conversation chatbox
     */

    $('a.conversation').click(function (e) {
        e.preventDefault();
        var conversation_id = $(this).data('cid');
        chatBox.chatWith(conversation_id);
    });

    /**
     * Listen on click' in our chat textarea and call the
     * chatInputKey in chat.js for inspection
     */
    $(document).on('click', '.chatboxtextarea', function (event) {
        var id = $(this).data('cid');
        jQuery.ajax({
            url: '/conversations/update_message',
            data: { conversation_id: id},
            type: "POST",

            success: function(data) {
                console.log("success");
            },
            failure: function() {
                console.log("Unsuccessful");
            }
        });
    });

}

$(document).ready(ready);
$(document).on("page:load", ready);