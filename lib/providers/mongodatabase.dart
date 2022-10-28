import 'dart:developer';

import 'package:clickbyme/providers/mongodb_constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDB {
  static var db,
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
    db = await Db.create(MONGO_URL);
    await db.open();
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
}
