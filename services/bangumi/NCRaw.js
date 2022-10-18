// 不懂为什么同一时间api返回的数据不一样
// 有时候返回的是最新的，有时候返回的是稍微旧的

let regex = new RegExp('(孤獨搖滾|电锯人)');
let oldData
let minutes = 1
let the_interval = minutes * 60 * 1000;
let ID = process.env.ID
let TOKEN = process.env.TOKEN

console.log(process.env)

async function init() {
    let res = await fetch('https://nc.raws.dev/0:/', { method: 'POST', body: JSON.stringify({ page_index: 0 }) });
    let json = await res.json();
    oldData = json.data.files
}

async function sendTG(name) {
    await fetch(`https://api.telegram.org/bot${TOKEN}/sendMessage?chat_id=${ID}&text=${name}`);
    //change mp4 or mkv to zip
    tmp = name.slice(0, -3) + "zip"
    let url = `https://nc.raws.dev/0:/` + tmp
    await fetch(`https://api.telegram.org/bot${TOKEN}/sendMessage?chat_id=${ID}&text=mpv '${url}'`);
}

async function main() {
    await init();
    setInterval(async () => {
        let res = await fetch('https://nc.raws.dev/0:/', { method: 'POST', body: JSON.stringify({ page_index: 0 }) });
        let json = await res.json();
        let newData = json.data.files
        newData.forEach(newElement => {
            let newEntry = true

            oldData.forEach(oldElement => {
                if (Date.parse(newElement.modifiedTime) <= Date.parse(oldElement.modifiedTime)) {
                    newEntry = false
                }
            })

            if (newEntry) {
                let episode = newElement.name

                console.log("Result: " + episode)

                if (regex.test(episode)) {
                    sendTG(episode)
                }
            }
        })

        if (Date.parse(newData[0].modifiedTime) > Date.parse(oldData[0].modifiedTime)) {
            oldData = newData;
        }

    }, the_interval);

}

main();
