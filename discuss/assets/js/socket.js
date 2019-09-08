import {Socket} from "phoenix"
let socket = new Socket("/socket", {params: {token: window.userToken}})

// connect to backend server socket
socket.connect()

const createSocket = (topicId) => {
  // Now that you are connected, you can join channels with a topic:
  // let channel = socket.channel("comments:1", {})
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
    .receive("ok",    resp => { 
      // console.log("Joined successfully", resp.comments);
      renderComments(resp.comments);
    })
    .receive("error", resp => { 
      console.log("Unable to join", resp);
    })

  channel.on(`comments:${topicId}:new`, renderComment)

  document.querySelector('button').addEventListener('click',  function() {
    const content = document.querySelector('textarea').value;
    channel.push('comment:add', {content: content});
  });
}

// for initial load
function renderComments(comments) {
  const renderedComments = comments.map(comment => {
    return commentTemplate(comment);
    // return (
    //   `<li class='collection-item'>  
    //     ${comment.content}
    //   </li>`); 
    // return ("<li class='collection-item'>" + String(comment.content) + "</li>");
  });
  document.querySelector('.collection').innerHTML = renderedComments.join('');
}

// adds to the existing list
// function renderComment(comment) {
//   const renderedComment = commentTemplate(comment);
//   document.querySelector('.collection').innerHTML += renderedComment;
// }
// adds to the existing list
function renderComment(event) {
  const renderedComment = commentTemplate(event.comment);
  document.querySelector('.collection').innerHTML += renderedComment;
}

//
function commentTemplate(comment) {
  return(`<li class='collection-item'>  
      ${comment.content}
    </li>`);
}
window.createSocket = createSocket;

// temp solution to push to server
// document.querySelector('button').addEventListener('click',  function() {
//   channel.push('comment:hello', {hi: 'there'})
// });

// export default socket
