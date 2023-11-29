import { fetch } from 'wix-fetch';

// 当年龄和性别选项变化时触发的函数
export function age_gender_change(event) {
    const ageSelection = $w('#age').value;
    const genderSelection = $w('#gender').value;

    // 确保两个选项都被选中了
    if (ageSelection && genderSelection) {
        readDataAndUpdateResults(ageSelection, genderSelection, 'deadlift.txt', '#result', '#text1');
        readDataAndUpdateResults(ageSelection, genderSelection, 'throw.txt', '#result2', '#text2');
        readDataAndUpdateResults(ageSelection, genderSelection, 'pushup.txt', '#result3', '#text3');
        readDataAndUpdateResults(ageSelection, genderSelection, 'sdc.txt', '#result4', '#text4');
        readDataAndUpdateResults(ageSelection, genderSelection, 'plank.txt', '#result5', '#text5');
        readDataAndUpdateResults(ageSelection, genderSelection, 'run.txt', '#result6', '#text6');
    }
}
async function readDataAndUpdateResults(age, gender, fileName, resultSelector, textSelector) {
    try {
        const response = await fetch(`https://raw.githubusercontent.com/haohuazheng3/gym/main/${fileName}`);
        const text = await response.text();
        const lines = text.split('\n');

        // 解析第一行，确定年龄对应的列
        const ageColumns = getAgeColumns(age, lines[0]);

        // 解析第二行，确定性别对应的列
        const genderColumn = getGenderColumn(gender, lines[1], ageColumns);

        // 从第三行开始读取指定列的数据，并更新结果选项
        updateResultOptions(lines, genderColumn, resultSelector);
    } catch (error) {
        console.error('Error reading data:', error);
    }
}

// 获取年龄对应的列
function getAgeColumns(age, firstLine) {
    const ages = firstLine.split(' ');
    const ageRange = age.split('-').map(Number);
    let columns = [];

    ages.forEach((item, index) => {
        const itemRange = item.split('-').map(Number);
        if (itemRange[0] <= ageRange[1] && itemRange[1] >= ageRange[0]) {
            columns.push(index);
        }
    });

    return columns;
}

// 获取性别对应的列
function getGenderColumn(gender, secondLine, ageColumns) {
    const genders = secondLine.split(' ');
    return ageColumns.find(column => genders[column] === gender);
}

// 更新结果选项
function updateResultOptions(lines, column, resultSelector) {
    let options = [];

    for (let i = 2; i < lines.length; i++) {
        const line = lines[i].split(' ');
        if (line[column] !== '---') {
            options.push({ "value": i.toString(), "label": line[column] });
        }
    }

    $w(resultSelector).options = options;
}

export function result_change(event, fileName, textSelector, prefix) {
    const selectedLineIndex = parseInt(event.target.value);
    if (isNaN(selectedLineIndex)) return;

    fetch(`https://raw.githubusercontent.com/haohuazheng3/gym/main/${fileName}`)
        .then(response => response.text())
        .then(text => {
            const lines = text.split('\n');
            if (selectedLineIndex >= 0 && selectedLineIndex < lines.length) {
                const selectedLine = lines[selectedLineIndex].split(' ');
                $w(textSelector).text = prefix + selectedLine[0]; // 在文本前加上预设的文本
                calculateAndUpdateTotalScore(); // 更新总分
            }
        })
        .catch(error => {
            console.error('Error reading data:', error);
        });
}

function calculateAndUpdateTotalScore() {
    let totalScore = 0;

    // 将每个项目的分数相加
    totalScore += parseInt($w('#text1').text.split(': ')[1]) || 0;
    totalScore += parseInt($w('#text2').text.split(': ')[1]) || 0;
    totalScore += parseInt($w('#text3').text.split(': ')[1]) || 0;
    totalScore += parseInt($w('#text4').text.split(': ')[1]) || 0;
    totalScore += parseInt($w('#text5').text.split(': ')[1]) || 0;
    totalScore += parseInt($w('#text6').text.split(': ')[1]) || 0;

    // 更新总分显示
    $w('#text7').text = `Total Score: ${totalScore}`;
}

// 绑定事件处理器
$w.onReady(function () {
    $w('#age').onChange(age_gender_change);
    $w('#gender').onChange(age_gender_change);
    $w('#result').onChange((event) => result_change(event, 'deadlift.txt', '#text1', 'Deadlift Score: '));
    $w('#result2').onChange((event) => result_change(event, 'throw.txt', '#text2', 'SP Throw Score: '));
    $w('#result3').onChange((event) => result_change(event, 'pushup.txt', '#text3', 'Push-up Score: '));
    $w('#result4').onChange((event) => result_change(event, 'sdc.txt', '#text4', 'SDC Score: '));
    $w('#result5').onChange((event) => result_change(event, 'plank.txt', '#text5', 'Palnk Score: '));
    $w('#result6').onChange((event) => result_change(event, 'run.txt', '#text6', '2-Miles Run Score: '));
});