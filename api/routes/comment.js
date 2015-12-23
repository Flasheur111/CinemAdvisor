/**
 * Created by Francois on 20/12/2015.
 */
var express = require('express');
var MongoClient = require('mongodb').MongoClient;
var config = require('../config')
var url = config.url_api;
var router = express.Router();

/* Add a comment */
router.get('/add/:idcinema/:idroom/:comment/:user/:grade', function (req, res, next) {
    var idcinema = req.params.idcinema;
    var idroom = req.params.idroom;
    var comment = req.params.comment;
    var user = req.params.user;
    var grade = req.params.grade;

    if (idcinema == null || idroom == null || comment == null || user == null || grade == null) {
        res.send({"error": "arguments"});
        return;
    }

    MongoClient.connect(url, function (err, db) {
        var toInsert = {'idcinema': idcinema, 'idroom': idroom, 'comment': comment, 'user': user, 'grade': grade, 'date': new Date() };
        db.collection('comment').insert(toInsert);
        db.close();
        res.send({"error": "ok", "inserted": toInsert});
    });
});

/* Get all comments  */
router.get('/list', function (req, res, next) {
    MongoClient.connect(url, function (err, db) {
        db.collection('comment').find().toArray(function (err, doc) {
            db.close();
            res.send(doc);
        });
    })
});

router.get('/list/:idcinema/:idroom', function (req,res, next) {
    var idcinema = req.params.idcinema;
    var idroom = req.params.idroom;

    if (idcinema == null || idroom == null) {
        res.send({"error": "arguments" });
        return;
    }

    MongoClient.connect(url, function (err, db) {
       db.collection('comment').find({ 'idcinema': idcinema, 'idroom' : idroom}).sort({ date: -1 }).toArray(function(err, doc) {
          db.close();
           res.send(doc);
       });
    });
});

/* Get comments of cinema and rooms */
router.get('/list/:idcinema/:roomname', function (req, res, next) {
    var id = req.params.idcinema;
    var room = req.params.roomname;

    if (id == null || roomname) {
        res.send({"error": "arguments"});
        return;
    }

    MongoClient.connect(url, function (err, db) {
        db.collection('comment').find({"idcinema": id, "roomname": room}).toArray(function (err, doc) {
            db.close();
            res.send(doc);
        });
    })
});

/* Drop comments */
router.get('/drop', function (req, res, next) {
    MongoClient.connect(url, function (err, db) {
        db.collection('comment').drop();
        db.close();
        res.send({"error": "ok"});
    });
});

module.exports = router;