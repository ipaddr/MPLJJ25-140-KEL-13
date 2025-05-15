const validateInput = (req, res, next) => {
  const { email, password } = req.body;

  // Validasi email kosong
  if (!email || typeof email !== 'string') {
    return res.status(400).json({ message: 'Email wajib diisi dan harus berupa teks' });
  }

  // Validasi format email sederhana
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({ message: 'Format email tidak valid' });
  }

  // Validasi password
  if (!password || typeof password !== 'string') {
    return res.status(400).json({ message: 'Password wajib diisi dan harus berupa teks' });
  }

  if (password.length < 6) {
    return res.status(400).json({ message: 'Password minimal 6 karakter' });
  }

  next(); // Lanjut ke controller jika valid
};

module.exports = validateInput;
