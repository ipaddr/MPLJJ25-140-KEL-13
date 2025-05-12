function calculateScore(report) {
  let score = 100;
  if (report.roofLeak) score -= 30;
  if (report.brokenToilet) score -= 20;
  // Tambahkan logika lainnya sesuai kebutuhan
  return score;
}

module.exports = calculateScore;
