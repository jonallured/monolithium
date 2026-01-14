# Hangout Feature Implementation Plan

## Overview
A one-to-many video broadcast feature for a Rails app where an authenticated broadcaster can stream video/audio to multiple viewers who can show their presence with names.

## Requirements
- Broadcaster page (authenticated): `/hangout/booth`
- Viewer page (public): `/hangout/watch`
- Live viewer presence with names
- Fully ephemeral (no database persistence)
- Support for ~12 concurrent viewers
- Deploy to Heroku

## Technical Stack
- **Backend**: Rails (existing Action Cable setup)
- **WebRTC**: Peer-to-peer connections (broadcaster → each viewer)
- **Signaling**: Action Cable via existing Redis setup
- **STUN**: Free public STUN servers (Google)
- **No TURN server** (start without, add only if needed)

## Connection Details
- Upload bandwidth: 191 Mbps (sufficient for 30-50 viewers at 2-3 Mbps each)
- Target: ~12 concurrent viewers
- Connection: Direct peer-to-peer WebRTC

## Implementation Components

### 1. Routes
```ruby
# config/routes.rb
namespace :hangout do
  get 'watch'
  get 'booth'
end
```

### 2. Controller
```ruby
# app/controllers/hangout_controller.rb
class HangoutController < ApplicationController
  before_action :authenticate_user!, only: [:booth]
  
  def watch
    # Public page - anyone can watch
  end
  
  def booth
    # Authenticated - only broadcaster can access
  end
end
```

### 3. Action Cable Channel
```ruby
# app/channels/hangout_channel.rb
class HangoutChannel < ApplicationCable::Channel
  def subscribed
    stream_from "hangout"
  end

  def receive(data)
    # Relay signaling data between broadcaster and viewers
    ActionCable.server.broadcast("hangout", data)
  end
  
  def viewer_joined(data)
    # Broadcast new viewer presence to everyone
    ActionCable.server.broadcast("hangout", {
      type: "viewer_joined",
      name: data["name"],
      viewer_id: data["viewer_id"]
    })
  end
  
  def viewer_left(data)
    # Broadcast viewer departure
    ActionCable.server.broadcast("hangout", {
      type: "viewer_left",
      viewer_id: data["viewer_id"]
    })
  end
end
```

### 4. Broadcaster Page (`/hangout/booth`)

**Functionality:**
- Authenticate user
- Request camera/microphone access via `getUserMedia()`
- Display local video preview
- Create WebRTC peer connection for each viewer that joins
- Show live list of current viewers with names
- Handle viewer joins/leaves

**Key JavaScript Flow:**
1. Get local media stream
2. Display in local `<video>` element
3. Subscribe to Action Cable `HangoutChannel`
4. Listen for viewer join events
5. For each viewer:
   - Create `RTCPeerConnection`
   - Add local stream tracks
   - Create and send SDP offer via Action Cable
   - Handle ICE candidates
   - Handle SDP answer from viewer
6. Update viewer list UI in real-time

**WebRTC Config:**
```javascript
const config = {
  iceServers: [
    { urls: 'stun:stun.l.google.com:19302' }
  ]
};
```

### 5. Viewer Page (`/hangout/watch`)

**Functionality:**
- Prompt for viewer name
- Connect to broadcaster via WebRTC
- Display broadcaster's video/audio stream
- Show list of other current viewers
- Announce presence to other viewers

**Key JavaScript Flow:**
1. Prompt user for name (store in session/local storage)
2. Generate unique viewer ID
3. Subscribe to Action Cable `HangoutChannel`
4. Announce presence via `viewer_joined` action
5. Wait for SDP offer from broadcaster
6. Create `RTCPeerConnection`
7. Set remote description (offer)
8. Create and send SDP answer
9. Handle ICE candidates
10. Display remote stream in `<video>` element
11. Update viewer list as others join/leave
12. Send `viewer_left` on page unload

### 6. Message Types (Action Cable)

**Signaling Messages:**
- `offer`: SDP offer from broadcaster to specific viewer
- `answer`: SDP answer from viewer to broadcaster
- `ice_candidate`: ICE candidates from either party

**Presence Messages:**
- `viewer_joined`: New viewer announces presence with name
- `viewer_left`: Viewer disconnects

**Message Structure:**
```javascript
{
  type: "offer|answer|ice_candidate|viewer_joined|viewer_left",
  viewer_id: "unique-id",
  name: "viewer name", // only for viewer_joined
  sdp: {...}, // only for offer/answer
  candidate: {...} // only for ice_candidate
}
```

## Data Flow

### Viewer Joining
1. Viewer opens `/hangout/watch`, enters name
2. Viewer sends `viewer_joined` via Action Cable
3. Broadcaster receives join event, creates peer connection
4. Broadcaster creates SDP offer, sends to viewer
5. Viewer receives offer, creates peer connection
6. Viewer sends SDP answer back to broadcaster
7. Both exchange ICE candidates
8. Connection established, viewer sees stream
9. All viewers see updated viewer list

### Viewer Leaving
1. Viewer closes tab/navigates away
2. `beforeunload` event sends `viewer_left` message
3. Broadcaster closes that peer connection
4. All viewers update their viewer list

## State Management

**Broadcaster maintains:**
- Map of viewer_id → RTCPeerConnection
- List of current viewers (id + name)

**Viewer maintains:**
- Own viewer_id and name
- Single RTCPeerConnection to broadcaster
- List of other current viewers

**All state is ephemeral:**
- Nothing persisted to database
- All state cleared on page reload
- No history or analytics

## Code Estimates
- Controller: ~10 lines
- HangoutChannel: ~30 lines
- Booth page (HTML + JS): ~150-200 lines
- Watch page (HTML + JS): ~150-200 lines
- Total new code: ~350-450 lines

## Deployment Notes
- Action Cable already configured with Redis
- Heroku SSL provides HTTPS (required for getUserMedia)
- No additional Heroku configuration needed
- WebRTC connections are peer-to-peer (don't go through Heroku)

## Future Enhancements (Not in Initial Implementation)
- Chat functionality
- Screen sharing
- Recording capability
- Viewer analytics/history
- Multiple simultaneous broadcasts
- TURN server for better connectivity
- Adaptive bitrate streaming
