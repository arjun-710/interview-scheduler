
# Interview Scheduler

## Technologies

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=flutter&logoColor=white) ![Firebase](https://img.shields.io/badge/firebase-ffca28?style=flat&logo=firebase&logoColor=white)

## App View

<div  align="center">

<a href="https://ibb.co/wCbjz5j"><img src="https://i.ibb.co/QnqtKyt/addUser.jpg" alt="addUser" border="0"></a>
<a href="https://ibb.co/NTvqJJS"><img src="https://i.ibb.co/MBvHtt6/add-meeting.jpg" alt="add-meeting" border="0"></a>
<a href="https://ibb.co/4J9WtCS"><img src="https://i.ibb.co/rvTk0qp/add-participants.jpg" alt="add-participants" border="0"></a>
<a href="https://ibb.co/0MZ8yh8"><img src="https://i.ibb.co/swQk9yk/meeting-detail.jpg" alt="meeting-detail" border="0"></a>
<a href="https://ibb.co/VmZ4F33"><img src="https://i.ibb.co/gVpK066/select-time.jpg" alt="select-time" border="0"></a>
<a href="https://ibb.co/wQBFMBw"><img src="https://i.ibb.co/6tr7gr1/validation.jpg" alt="validation" border="0"></a>
<a href="https://ibb.co/8Bc6tNG"><img src="https://i.ibb.co/N3SZbtf/your-meetings.jpg" alt="your-meetings" border="0"></a>

</div>

## Table of contents

- [About](#about)

- [Installation](#installation)

- [EndPoints](#EndPoints)

- [Features](#Features)

## About

- An App to schedule interviews.
- Send emails upon invitation.
- Database used is Firesbase Firestore.

## Installation

```js

# clone repo

$ git clone https://github.com/arjun-710/interview-scheduler

$ cd interview-scheduler



#install dependencies
$ flutter packages get



# run App
$ flutter run
```

## EndPoints

| Endpoint | Info |

| ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |

| /addUser| `A page to add User to the database` |

| /landing| `A page to show upcoming meetings` |

| /meetingDetail| `A page to show detailed info of a meeting` |

| /addMeeting| `A page to add Meeting by selecting date, time and title` |

| /addParticipants| `A page to add participants of a meeting to be scheduled` |

| /validateMeeting | `A page to validate and filter out unavailable participants` |

## Features

- Add users which can then be assigned interviews.

- Schedule meeting/interviews without clashing.

- Know the unavailable participants.

- Send email to all participants.
