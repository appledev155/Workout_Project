// Flag Status Details
// 0 - channel not created -- agent can see it,
// 1 - created at pubnub -- [request activated and both user can see it],
// 2 - Status used if user leave/block (block for private channel, leave for public channel)}, update channelData ADD (leaveBlock)
// 3 - chat delete by both user, (deleteBy: {15})
// 4 - deleted by both user,
// 5 - channel deactivate - [Admin approved new request that reason old request deactivate],
// 6 - agent not responded to the request.
// 7 - deleted by admin.
// Do not send the channel created by logged in user and chat_flg 0.

List<String> signalType = [
  'typingOn',
  'typingOff',
  'read',
  'delivered',
  'blocked',
  'unblock',
  'leaveChat',
  'delete',
  'profileUpdate'
];

List<dynamic> cardTypeList = [
  'text',
  'URL',
  'onlyImages',
  'onlyMedia',
  'propertyDetail',
  'privateProperty',
  "call",
  "whatsapp"
];

List<dynamic> cardTypePlaceholderList = [
  "firstMessage",
  "mediaPlaceholder",
  "privatePropertyPlaceholder"
];
