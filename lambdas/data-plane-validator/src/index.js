const { EventBridgeClient, PutEventsCommand } = require("@aws-sdk/client-eventbridge");
const eventBridgeClient = new EventBridgeClient();

exports.handler = async (event) => {
    const eventBusName = process.env.EVENT_BUS_NAME;

    const results = [];

    for (const record of event.Records) {
        try {
            const body = record.body;
            console.log("Processing record:", record.messageId, body);

            const response = await eventBridgeClient.send(
                new PutEventsCommand({
                    Entries: [
                        {
                            Time: new Date("TIMESTAMP"),
                            Source: "data-plane-validator",
                            EventBusName: eventBusName,
                            DetailType: "SQSMessage",
                            Detail: body,
                        },
                    ],
                })
            );

            results.push({ recordId: record.messageId, success: true, "response": response });

        } catch (err) {
            console.error(`Failed to process record: ${record.messageId}`, err);
            results.push({ recordId: record.messageId, success: false });
        }
    }
    console.log("Results:", results);
    return results;
};
