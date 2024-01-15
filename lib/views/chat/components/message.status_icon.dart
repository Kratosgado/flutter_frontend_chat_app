import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/models.dart';

Icon messageStatusIcon(MessageStatus status) => Icon(
      switch (status) {
        MessageStatus.SENDING => Icons.lock_clock,
        MessageStatus.SENT => Icons.check,
        MessageStatus.DELIVERED => Icons.check_outlined,
        MessageStatus.SEEN => Icons.remove_red_eye,
      },
      size: 10,
    );
