import 'dart:developer';

import 'package:clickbyme/providers/mongodb_constant.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDB {
  static var res,
      collection_user,
      collection_share,
      collection_people,
      collection_memo,
      collection_homeview,
      collection_tag,
      collection_memoallalarm,
      collection_eventnotice,
      collection_companynotice,
      collection_applicense,
      collection_noticebycompany,
      collection_noticebyusers;

  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open().then((success) {
      Hive.box('user_info').put('server_status', db.isConnected);
    });
    collection_user = db.collection(USER_COLLECTION);
    collection_share = db.collection(SHARE_COLLECTION);
    collection_people = db.collection(PEOPLE_COLLECTION);
    collection_memo = db.collection(MEMO_COLLECTION);
    collection_homeview = db.collection(HOMEVIEW_COLLECTION);
    collection_tag = db.collection(TAG_COLLECTION);
    collection_memoallalarm = db.collection(MEMOALLALARM_COLLECTION);
    collection_eventnotice = db.collection(EVENTNOTICE_COLLECTION);
    collection_companynotice = db.collection(COMPANYNOTICE_COLLECTION);
    collection_applicense = db.collection(APPLICENSE_COLLECTION);
    collection_noticebycompany = db.collection(APPNOTICEBYCOMPANY_COLLECTION);
    collection_noticebyusers = db.collection(APPNOTICEBYUSERS_COLLECTION);
  }

  static add(
      {required String collectionname,
      required Map<String, dynamic> addlist}) async {
    if (collectionname == 'user') {
      await collection_user.insertOne(addlist);
    } else if (collectionname == 'sharehome') {
      await collection_share.insertOne(addlist);
    } else if (collectionname == 'people') {
      await collection_people.insertOne(addlist);
    } else if (collectionname == 'memo') {
      await collection_memo.insertOne(addlist);
    } else if (collectionname == 'homeview') {
      await collection_homeview.insertOne(addlist);
    } else if (collectionname == 'tag') {
      await collection_tag.insertOne(addlist);
    } else if (collectionname == 'memoallalarm') {
      await collection_memoallalarm.insertOne(addlist);
    } else if (collectionname == 'eventnotice') {
      await collection_eventnotice.insertOne(addlist);
    } else if (collectionname == 'companynotice') {
      await collection_companynotice.insertOne(addlist);
    } else if (collectionname == 'applicense') {
      await collection_applicense.insertOne(addlist);
    } else if (collectionname == 'notibycompany') {
      await collection_noticebycompany.insertOne(addlist);
    } else if (collectionname == 'notibyusers') {
      await collection_noticebyusers.insertOne(addlist);
    }
  }

  static update(
      {required String collectionname,
      required String query,
      required String what,
      required Map<String, dynamic> updatelist}) async {
    if (collectionname == 'user') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_user.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'sharehome') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_share.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'people') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_people.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'memo') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_memo.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'homeview') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_homeview.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'tag') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_tag.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'memoallalarm') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_memoallalarm.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'eventnotice') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_eventnotice.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'companynotice') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_companynotice.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'applicense') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_applicense.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'notibycompany') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_noticebycompany.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'notibyusers') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_noticebyusers.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    }
  }

  static find({
    required String collectionname,
    required String query,
    required String what,
  }) async {
    if (collectionname == 'user') {
      await collection_user.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'sharehome') {
      res = await collection_share.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'people') {
      res = await collection_people.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'memo') {
      res = await collection_memo.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'homeview') {
      res = await collection_homeview.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'tag') {
      res = await collection_tag.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'memoallalarm') {
      res = await collection_memoallalarm.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'eventnotice') {
      res = await collection_eventnotice.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'companynotice') {
      res = await collection_companynotice.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'applicense') {
      res = await collection_applicense.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'notibycompany') {
      res = await collection_noticebycompany.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'notibyusers') {
      res = await collection_noticebyusers.find({query: what}).forEach((v) {
        res = v;
      });
    }
  }
}
