from flask import Flask, request, jsonify
import uuid
import json
from random import randint

f = open('questions.json')

# returns JSON object as
# a dictionary
questions = json.load(f)["trivia"]



app = Flask(__name__)


waiting_matches = []

deviceId_waiting_matchId_map = {}

deviceId_matchId_map = {}


current_matches = {}

@app.route('/match', methods=['GET'])
def get_match():
    deviceId = request.args.get('deviceId')
    print(f"deviceId: {deviceId}")
    if(deviceId in deviceId_matchId_map):
        return jsonify({'status': 'match_in_progress'})
    elif(deviceId in deviceId_waiting_matchId_map):
        return jsonify({'status': 'waiting'})
    elif(waiting_matches):
        match = waiting_matches.pop()
        # move match from waiting_matches to current_matches
        match_id = match["id"]
        del deviceId_waiting_matchId_map[match["startedDeviceId"]]
        startedDeviceId = match["startedDeviceId"]
        match["deviceTurn"] = startedDeviceId
        deviceId_matchId_map[deviceId] = match_id
        deviceId_matchId_map[startedDeviceId] = match_id
        match["joinerDeviceId"] = deviceId
        current_matches[match_id] = match
        return jsonify({'status': 'matched'})
    else:
        match_id = uuid.uuid1()
        match_request = {"startedDeviceId": deviceId, "id": match_id}
        deviceId_waiting_matchId_map[deviceId] = match_id
        waiting_matches.append(match_request)
        return jsonify({'status': 'waiting'})


def get_next_question():
    index = randint(0, len(questions)-1)
    return questions[index]

def get_match(deviceId):
    matchId = deviceId_matchId_map[deviceId]
    match = current_matches[matchId]
    return match

@app.route('/question', methods=['GET'])
def get_question():
    deviceId = request.args.get('deviceId')
    print(f"deviceId: {deviceId}")
    if(deviceId not in deviceId_matchId_map):
        return jsonify({'status': 'error', "msg": "device does not have an active match"})
    match = get_match(deviceId)
    print("match: ",  match)
    if("winner" in match):
        del deviceId_matchId_map[deviceId]
        if(match["winner"] == deviceId):
            return jsonify({'status': 'you_won'})
        else:
            return jsonify({'status': 'lost'})
    if(match["deviceTurn"] == deviceId):
        question = get_next_question()
        match["question"] = question
        return jsonify({'status': 'new_question', "question": question})
    else:
        return jsonify({'status': 'not_your_turn'})

@app.route('/question', methods=['POST'])
def post_question():
    deviceId = request.args.get('deviceId')
    answer = request.args.get('answer')
    print(f"deviceId: {deviceId}")
    if(deviceId not in deviceId_matchId_map):
        return jsonify({'status': '©', "msg": "device does not have an active match"})
    match = get_match(deviceId)
    if(match["deviceTurn"] != deviceId):
        return jsonify({'status': 'not_your_turn'})
    question = match["question"]
    otherDeviceId = (match["startedDeviceId"]==deviceId and match["joinerDeviceId"]) or match["startedDeviceId"]
    if(answer == question["answer"]):
        match["deviceTurn"] = otherDeviceId
        return jsonify({'status': 'correct'})
    else:
        match["winner"] = otherDeviceId
        del deviceId_matchId_map[deviceId]
        return jsonify({'status': 'lost'})



if __name__ == "__main__":
    app.run()