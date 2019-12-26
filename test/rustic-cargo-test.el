;; -*- lexical-binding: t -*-

(ert-deftest rustic-test-cargo-test-with-prefix-arg ()
  (should (string= rustic-test-arguments ""))
  (let* ((string "#[test]
                   fn it_works1() {
                      assert_eq!(2 + 2, 3);
                   }
                   #[test]
                   fn it_works2() {
                      assert_eq!(2 + 2, 3);
                   }")
         (default-directory (rustic-test-count-error-helper string))
         (current-prefix-arg 4)
         (rustic-test-arguments  "it_works2")
         (proc (call-interactively 'rustic-cargo-test))
         (buf (process-buffer proc)))
    (while (eq (process-status proc) 'run)
      (sit-for 0.1))
    (with-current-buffer buf
      ;; only test it_works2 is supposed to run
      (should-not (string-match "it_works1" (buffer-substring-no-properties (point-min) (point-max))))
      (should (string-match "it_works2" (buffer-substring-no-properties (point-min) (point-max))))
      ;; (print (buffer-substring-no-properties (point-min) (point-max)))
      ;; check if buffer has correct name and correct major mode
      (should (string= (buffer-name buf) rustic-test-buffer-name))
      (should (eq major-mode 'rustic-cargo-test-mode)))
    ;; passed test should be saved in `rustic-test-arguments'
    (should (string= rustic-test-arguments "it_works2"))))
    
    
  