---
layout: post
title: “The journey of a chat message“
description: ""
category: ""
tags: []
---

It all starts at that magical moment, that moment when the user clicks the `send` button. It is exactly that moment where we start our journey. The goal is to get the message that was written by the user into our system, all the way down to a point where the other participating user can see the message. We know it will be a long and dangerous journey. One where we will face some serious threats.

## Preparing

A journey cannot start without good preparation. We prepare ours by creating a new unique identifier that gives our journey an identity. We persist this identifier, and the message the was written by the user to the local storage. This will be our first  safe point that we can use to **continue from in case of failure**.

Now we append the message to the conversation on the screen to give the user feedback he or she just send a message.

## Getting it out

It is now time to try to get our message out. We do so by making a `POST /conversation/:id` request to the `chat` service. After we send the request we expect a response within a certain time period. This means the following can happen:

1. ok - we get an acknowledgement.
2. failure - we get an error response.
3. timeout - we got no response at all.

## happy path
If we are lucky we get an acknowledgement back that the request was handled correctly. In that case we update the state in the UI to let the user know the message got sent.

## on failure
Failure can happen because of many reasons. It might be that our request was invalid because of some validation rules. Usually these errors are just presented to the user, since in that case he or she is the only one that can fix it.

It might also be that the service was not able to process our request because of an server error. In that case actually just send the request again. We do wait a bit longer for every time we retry, that pattern is known as [exponential backoff](http://en.wikipedia.org/wiki/Exponential_backoff).

## note on timeouts

A timeout can mean many things. It might mean that the service never received our request because it got lost. Or that the service is down and is therefor not able to respond. On the other hand, it might actually got our message and handled it correctly but it is just the response back to us that got lost.

That is what makes timeouts so hard, there is no way to tell if the request got handled or not.

This means we handle timeouts the same way as failures, by retrying the request.This means our `chat` service needs to be able to handle duplicate requests, but more about that later.

## handling the request

The `chat` service is responsible for handling the request. It starts by validating the request. For example, is `by_user_id` set and is the `message_text` not empty. When it thinks it is invalid, it sends back an error response describing why the request is rejected.

When all is valid it publishes a `message_send` event to record the fact. When the event publishing fails it will respond with an server error.

When the event publishing succeeds, we reached the next safe point. 