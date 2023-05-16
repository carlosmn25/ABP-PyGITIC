const express = require('express')
const router = express.Router()
const aws = require('aws-sdk')

const credentials = new aws.SharedIniFileCredentials({profile: 'default'})
aws.config.credentials = credentials

const ddb = new aws.DynamoDB({region: 'us-east-1'})

router.get('/', (req, res) => {

    //Obtener datos de dynamoDB
    var estadisticas_prom = ddb.scan({
        TableName: 'Estadisticas'
    }).promise()

    Promise.all([estadisticas_prom]).then((values) => {
        res.render('statistics/index', {
            estadisticas: values[0].Items,
        })
    })
})

module.exports = router;