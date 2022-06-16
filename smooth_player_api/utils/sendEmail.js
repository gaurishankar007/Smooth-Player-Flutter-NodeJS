const nodemailer = require("nodemailer");

const sendEmail = (email, subject, text) => {
    try {
        const transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: "gaurisharma371@gmail.com",
                pass: "yfradxhdpibsmlhx",
            },
        });
        
        const mailOptions = {
            from: "gaurisharma371@gmail.com",
            to: email,
            subject: subject,
            text: text,
        };

        transporter.sendMail(mailOptions, function(error, info) {
            if (error) {
                console.log(error)
            }
            else {
                console.log("Email sent successfully: "+ info.response)
            }
        });
    } 
    catch (error) {
        console.log(error, "Email not sent");
    }
};

module.exports = sendEmail;